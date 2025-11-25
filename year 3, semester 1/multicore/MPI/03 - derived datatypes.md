---
related to:
created: 2025-11-03, 15:29
updated: 2025-11-25T17:13
completed: false
---
# derived datatypes
*derived datatypes* are used to represent any collection of data items in memory
- this is achieved by storing both their type and their relative locations in memory
if a function that sends data knows this information about a collection, it can collect the items from memory to send them !
- same thing for a function that receives data: it can distribute the items into their correct destinations in memory
>[!example] esempio
>a naive implementation like the folllowing doesnt work because of the possibility of different implementation of a structure’s layout on different platforms !
>```c
>const int N = ...;
>typedef struct Point{
>	int x;
>	int y;
>	int color;
>};
>
>Point image[N];
>MPI_Send(image, N*sizeof(Point), .....);
>```
>![[Pasted image 20251103153422.png]]

## implementation
formally, it consists of a sequence of basic MPI data types, together with *a displacement* for each of the data types
## `MPI_Type_create_struct()`
it builds a derived datatype that consists of individual elements that have different basic types.

>[!syntax] syntax
>```c
>int MPI_Type_create_struct(
>	int           count,                    // in
>	int           array_of_blocklengths[],  // in
>	MPI_Aint      array_of_displacements[], // in
>	MPI_Datatype  array_of_types[],         // in
>	MPI_Datatype* new_type_p                // out
>);
>```

### `MPI_Get_address()`
however, due to the different implementations of datatype, we can’t be sure of the size of the displacements
>[!syntax] syntax
>```c
>int MPI_Get_address(
>	void*     location_p, // in
>	MPI_Aint* address_p   // out
>);
>```

>[!example] example
>```c
>struct t {
>	double a;
>	double b;
>	int n;
>};
>```
>
>```c
>MPI_Aint a_addr, b_addr, n_addr;
>
>MPI_Get_address(&a, &a_addr);
>array_of_displacements[0] = 0; // start
>MPI_Get_address(&b, &b_addr);
>array_of_displacements[1] = b_addr-a_addr; //first displacement
>MPI_Get_address(&c, &c_addr);
>array_of_displacements[2] = c_addr-a_addr; // second displacement (from a, not from b !)
>```
>
>we cant do:
>```c
>array_of_displacements[0] = 0;
>array_of_displacements[1] = &b - &a;
>array_of_displacements[2] = &n - &a;
>```
because `&` cast-expressions return a *pointer*, not an *address*. ISO C does not require that the value of a pointer (or the pointer cast to int) be the absolute address of the object pointed at (although this is commonly the case).
furthermore, referencing may not have a unique definition on machines with a segmented address space. the use of `MPI_Get_address` guarantees portability to any machine

## `MPI_Type_commit()`
`MPI_Type_commit` allows the MPI implementation to optimize its internal representation of the derived datatype for use in communication functions !
- it is *necessary* for the derived datatype to work !!!
>[!syntax] syntax
>```c
>int MPI_Type_commit(MPI_Datatype* new_mpi_t_p); //in&out
>```
## `MPI_Type_free()`
`MPI_Type_free` frees any additional storage used for the derived datatype. we can call this function when we’re finished with our new type
- ill take it as good practice ig.
>[!syntax] syntax
>```c
>int MPI_Type_free(MPI_Datatype* old_mpi_t_p); //in&out
>```

>[!info] this is what you get. this is what you get when you mess with us …..
![[Pasted image 20251103155000.png]]