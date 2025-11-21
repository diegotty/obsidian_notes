---
related to:
created: 2025-03-02T17:41
updated: 2025-11-21T11:32
completed: false
---
the performance of microprocessors has stopped increasing in a fast rate in the last 20 years, going from 50% a year  from 1986 to 2003, to a 4% increase in the last 10 years 
also, traditionally we relied on performance increase caused by increase in the **density of transistors**. said approach is not sustainable anymore, as the increased power consumption increases the heat, making the processors unreliable. we run into physical limits !
for that reason, instead of trying to have more powerful monolithic processors, we are putting **multiple processors on a single integrated circuit**

to benefit from this approach, we must be aware of the multiple processors and know how to use them. we must **explicitly** write programs to exploit the available parallelism (as this can’t be done automatically in a reliable way)

>[!example] designing a new algorithm instead of repurposing a sequential one
let’s write an algorithm that computes $n$ values and adds them together
>```c
//sequential
>int sum = 0;
>for(int i = 0; i < n; i++){
>	x = compute_next_value(..);
>	sum += x;
>}
>```

```c
// parallel_1
// private variables for each core
int my_sum = 0;
int my_first_i = ...;
int my_last_i = ...;
for(my_i = my_first_i; my_i < my_last_i; my_i++){
	my_x = compute_next_value(...);
	my_sum += my_x;
}
```
each core will have a partial sum in `my_sum`, and each core will send its `my_sum` value to a **master** core which adds the final result
however, in this way, the master is doing all the work that comes with summing, while the other cores just send their data

let’s try pairing the cores so that core 0 adds its result with core 1’s, core 2 with core 3’s, etc..
after this first round, then core 0 adds its result with core 2, core 4 with core 6, etc..
// todo ADD IMG
## writing parallel programs
**task parallelism**: partition various tasks among the cores (each core works on every piece of data)
**data parallelism**: partition the data used in solving the problem among the cores (each core fully computes the data it works on)
>[!example] example
i need to grade 300 exams, each with 15 questions, and i have 3 teaching assistants
data parallelism: each assistant grades 100 exams
task parallelism: assistant 1 grades all the exams, but only questions 1-5. assistant 2 does the same but only questions 6-10. etc….

to write parallel programs, we need to coordinate the cores, for different reasons:
- **communication**: one core sends its partial sum to another core
- **load balancing**: share the work even3
- **synchronization**: each core works at its own pace, but must make sure some core does not get too far ahead

to write parallel programs, we will use four different extensions of the C API:
- **message-passing interface**
- **posix threads (pthreads)** 
- **openMP**
- **CUDA**
higher level libraries exist, but the tradeoff is performance
### types of parallel systems
#### memory
- **shared-memory**: all the cores can share access to the computer’s memory and the cores can be coordinated by having them examine and update shared memory locations
- **distributed-memory**: each core has its own, private memory. they communicate explicitly by sending messages across a network !
>[!info] image
![[memory.png]]
with distributed memory (right), cores are connected though a fast network

>[!info] distributed memory systems insight
![[Pasted image 20251103172359.png]]
multiple nodes/servers/blades are interconnected, through their NICS, to each other
>- we can have, as of today, up to 4 GPUs per node
>- we can have, as of today, up to one NIC per GPU !
>
>![[Pasted image 20251103172549.png]]
we will study *MPI* to parallelize over nodes, *pthread/OpenMP* to parallelize over *CPU cores*, and *CUDA* to parallelize over *GPU cores*
#### instructions
- **multiple-instruction multiple-data (MIMD)**: each core has its own control units (can execute different instructions, and have different fetch cycles) and can work independently from the others
- **single-instruction multiple-data (SIMD)**: the same instruction is executed across all cores, but each code does so on different data (if a core wants to execute another instruction, it has to stay idle while the other core does its instruction)
	- aka vector vector processing, this is the GPU’s architecture. in detail, the GPU is divided in groups of 32 cores. each group is SIMD, but between each other, they are MIMD, as each group has its own control unit

what programming languages will we use for different types of systems ? 

|      | shared-memory          | distributed-memory |
| ---- | ---------------------- | ------------------ |
| SIMD | CUDA                   |                    |
| MIMD | pthreads, openMD, CUDA | MPI                |
|      |                        |                    |
#### task parallelism
- **concurrent**: multiple tasks can be in progress at any time (at the same time) and each task can be independent from any other (in necessarily in parallel, can be done by interleaving)
- **parallel**: multiple tasks can be in progress at any time but need to *cooperate cloosely* (tasks are tightly coupled: for example, cores share the memory or are connected through a fast network)
- **distributed**: a program *might* need to cooperate with other programs (tasks are more loosely coupled: for example, services connected though the internet)
parallel and concurrent are distributed, and concurrent programs can be serial

>[!info] hardware
to write efficient code, its better to know on which hardware we are running the program on, to optimize for that !

## von neumann architecture
>[!info] von neumann 
![[Pasted image 20251012171318.png|400]]
>- the main memory is a collection of locations, and each location has an address used to access the content (data or instruction) in that location
>- as we already know, the CPU is comprised of the many units, like the CU, the registers (which store the state of the executing program), and the PC (also a register)
>- the interconnect is used to transfer data between the CPU and the memory. its traditionally a **bus**, but it can be much more complex
>	- tranferring data from memory to the registers is a bottleneck, known as **von neumann bottleneck**

>[!info] registers are SRAM
SRAM is a type of volatile memory, commonly found in CPUs, caches and registers. it uses flip-flops to store each bit of data, so it doesnt need memory refreshes (in DRAM, bits are stored as the presence or absence of a electric charge inside a capacitor. as time passes, the charge gets weaker, and cycles of refresh are used to keep the data inside the memory. of course refreshes are completely unnoticeable)