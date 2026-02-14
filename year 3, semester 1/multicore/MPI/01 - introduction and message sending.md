---
related to:
created: 2025-03-02T17:41
updated: 2026-02-14T14:41
completed: false
---
# introduction
MPI is a library used by distributed-memory systems
it uses the **SPMD** ((**single-program multiple-data**) parallel programming computing model, where one program is compiled and it gets executed by multiple processes.
we use if-else statements to specify what each process must do (similarly to what happens when you fork a process)
 - as the systems are distributed-memory, communications happen through message passing

```c
#include <stdio.h>
#include <mpi.h>

int main(void){
	MPI_Init(NULL, NULL);
	.... // where we can add MPI class
	printf("hello, world\n");
	MPI_Finalize();
	return 0;
}
```

>[!info] misc info
identifiers start with `MPI_`, and the first letter following underscore is uppercase

the return value of MPI functions is `int`, and it always returns a code that indicates an error

>[!info] compiling and execution
>```bash
>mpicc -g -wall -o mpi_hello mpi_hello.c
>```
>- `-g` produces debug information
>- `-Wall` turns on all warnings
>it is advised to use some kind of debugger (gdb (GNU debugger, fully terminal: ddd is its graphical frontend) / valgrind (old))
>```bash
>mpiexec -n <number of processes> <executable>
>```
>- `-n` specifies the number of processes that will execute the program
>```bash
>mpiexec -n 4 ./test: -n ddd ./test : -n 1 ./test
>```
runs the 5th process under the ddd debugger, and the other 5 normally

each process is identified by a **rank**, that starts from `0` to `p-1`
## communicators
a communicator is a collection of processes that can send messages to each other
- `MPI_Init()` defines a standard communicator, that consists of all the processes created when the program is started: `MPI_COMM_WORLD`

>[!warning] ranks and communicators
>id process is relative to what communicator it is in ! (the rank in `MPI_Comm_rank()`)

>[!info] return values
> all MPI functions return an `int`, which is used to communicate a state/error

### functions
- `int MPI_Comm_size(MPI_Comm comm, int* comm_sz_p)`
	- return the size (cardinality) of the communicator `comm` in `comm_sz_p`
- `int MPI_Comm_rank(MPI_Comm comm, int* my_rank_p)`
	- returns the rank of the process making the call, relative to the communicator `comm`, in `my_rank_p`
## message sending
>[!info] sending order
MPI requires that messages be **nonovertaking**: if process $q$ sends two messages to process $r$, the first message sent by $q$ must be available to $r$ before the second message
>- however, there is no restriction on the arrival of messages sent from different processes
### functions
- `int MPI_Send(void* msg_buf_p, int msg_size, MPI_Datatype msg_type, int dest, int tag, MPI_Comm communicator)`
	- `msg_buf_p`: start address of the block of memory to be sent
	- `msg_size`: number of elements of the message (of type `msg_type`)
	- `msg_type`: type of data being sent (parallel to int, char, float, …., but we pass a MPI enum value. for custom types (structs) , a new macro needs to be made !)
	- `dest`: rank of the receiver
	- `tag`: needs to match the receiver’s tag
	- `communicator`: communicator to be “used”
- `int MPI_Recv(void* msg_buf_p, int buf_size, MPI_Datatype buf_type, int source, int tag, MPI_Comm communicator, MPI_Status* status_p)`
	- `msg_buf_p`: start address of the memory to be filled with the message
	- `source`: rank of the sender (special values like `MPI_any_RANK` exist !)
	- `tag`: has to match with sender’s `tag`
	- `status_p`: info on what happened on the receive (ex: rank of the sender if `MPI_ANY_RANK` or `MPI_ANY_SOURCE` was used). its an struct that contains fields like `MPI_SOURCE`, `MPI_TAG`, `MPI_ERROR`
- `int MPI_Get_count(MPI_Status* status_p, MPI_Datatype type, int* count_p)`
	- given the status (which identifies the communication), and the type of the data recevied, it fills `count_p` with the number of `type` received
### data types

| MPI datatype       | C datatype           |
| ------------------ | -------------------- |
| MPI_CHAR           | signed char          |
| MPI_SHORT          | signed short int     |
| MPI_INT            | signed int           |
| MPI_LONG           | signed long int      |
| MPI_LONG_LONG      | signed long long int |
| MPI_UNSIGNED_CHAR  | unsigned char        |
| MPI_UNSIGNED_SHORT | unsigned short int   |
| MPI_UNSIGNED       | unsigned int         |
| MPI_UNSIGNED_LONG  | unsigned long int    |
| MPI_FLOAT          | float                |
| MPI_DOUBLE         | double               |
| MPI_LONG_DOUBLE    | long double          |
| MPI_BYTE           |                      |
| MPI_PACKED         |                      |

a message is **successfully** received if:
- `recv_type = send_type`
- `recv_buf_sz >= send_buf_sz`
also, a  receiver can get a message withouth knowing:
- the amount of data in the message
- the sender of the message (`MPI_ANY_SOURCE`)
- the tag of the message (`MPI_ANY_TAG`)
### blocking communication

>[!warning] assumptions
the exact behaviour of send and receive functions is determined by the MPI implementation, but !! even if you nkow your MPI implementation, stick to what the defined standard says ! don’t make implementation-specific assumptions, otherwise code will not be portable

the problem: when the send function returns, the sender does not know  if the message got delivered successfully, or if the message was sent at all. it doesn’t even know if its still in its memory, waiting to be sent. **however**, after the send function returns, the sender can alter the content of the buffer sent, as MPI guarantees the message will not be lost (that’s the only assumption we can make)

MPI has a buffer where it stores **some** (small enough) messages that were sent but still not received by anyone (as nobody called the receive function with the matching parameters).
however, this cant be done with very big messages, and in that cases, it behaves differently: MPI asks the receiver if it is ready to receive the message and waits for a reply before the returning the send call. during this period of time, the send **can be blocking !!** (however, it can be blocking even if the buffer sent is small. as we said, we can’t make assumptions)
- because of this overhead, we should limit send calls as much as possible, by not making a lot of small send calls, but rather send calls with bigger buffers
### point-to-point communication modes
the communication mode explained above is the **standard** communication mode. there are three more:
- **buffered**: the sending operation is always locally blocking: it will return as soon as the message is copied to a buffer. also, the buffer is user-provided
- **synchronous**: the sending operation will return only after the destination process has initiated and started retrieval of the message. this is a proper *globally blocking* operation, as the sender can be sure of the point where the receiver is without any further communication
- **ready**: the send operation will succeed only if a matching receive operation has been intiated already. otherwise, the function returns with an error code. the purpose of this mode is to reduce the overhead of handshaking operations !

such modes are implemented with `MPI_Bsend()`, `MPI_Ssend()` and `MPI_Rsend()`, that share the same arguments `(void *buf, int count, MPI_Datatype datatype, int dest, int tag, MPI_Comm comm)`

### non-blocking communication
buffered sends are considered bad for performance, because the caller has to block, waiting for the copy to take place. by using non-blocking communication, we allow computation and communication to overlap (as MPI/NIC handles the communication), as the send returns as soon as the MPI takes notice of the send call. we thereby maximize concurrency.

however, non-blocking calls don’t guarantee the *altering the buffer thing*, and the completion of the operations for both end-points has to be queried explicitly:
- for senders so that they can re-use the message buffer
- for receivers so that they can extract the message contents
#### functions
- `int MPI_Isend(void *buf, int count, MPI_Datatype datatype, int source, int tag, MPI_Comm comm, MPI_Request *req)`
	- non-blocking send
	- the `req` that is returned is a handle that allows a query on the status of the operation to take place
- `int MPI_Irecv(void  *buf, int count, MPI_Datatype datatype, int source, int tag, MPI_Comm comm, MPI_Request *req)`
- `int MPI_Wait(MPI_Request *req, MPI_Status *st)`
	- `*st`: is the address of the structure that will hold the communication information
	- blocking completion request, destroys the handle that is passed as argument
- `int MPI_Test(MPI_Request *req, int *flag, MPI_Status *st)`
	- `flag`: set to true only if the operation is complete
	- non-blocking completion request, destroys handle only if the operation was successful `flag = 1`
many variants of the wait operation are available: `MPI_Waitall()`, `MPI_Testall()`, `MPI_Waitany()`, `MPI_Testany()`, …

### `MPI_Sendrecv`
`MPI_Sendrecv` is an alternative in message sending: it allows, in a single combined function, to send a message to one destination and simultaneously receive a message from one source process
- it is blocking
- its primary role is to prevent deadlocks (as we know, sends can be blocking, so if two processes send a message at the same time to each other, a deadlock could happen)
- we don’t need to schedule the communication ourselves
- it is an atomic function
```c
int MPI_Sendrecv(
	void* send_buf_p,            // in
	int send_buf_size,           // in
	MPI_Datatype send_buf_type,  // in
	int dest,                    // in
	int send_tag,                // in
	void* recv_buf_p,            // out
	int recv_buf_size,           // in
	MPI_Datatype recv_buf_type,  // in
	int source,                  // in
	int recv_tag,                // in
	MPI_Comm communicator,       // in
	MPI_Status* status_p         // in
)
```
