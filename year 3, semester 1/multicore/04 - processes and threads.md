---
related to: "[[02 - parallel design patterns]]"
created: 2025-11-03, 17:38
updated: 2025-12-26T07:25
completed: false
---
with the introduction of openMP and pthreads, we study how to parallelize effectively between cores of a single CPU
# threads
*threads* are analogous to a “light-weight” process. it is the smallest unit of processing that can be scheduled and executed by an OS.
it is fundamental for *parallelism*, as each thread can be assignied to a different CPU core.
>[!info] rember
a CPU core is the fundamental execution unit, comprised by ALU, registers (with PC, IR, SP, ….), CU, and L1 cache
cores can indipendently run a separate thread or process at the same time, making for true (and almost linear) speedup

having a core that can handle 2 threads means that, with the same ALU, there are resources to save 2 process contexts. that way, context switching is faster (and context switching is very expensive !)

in a shared memory program, a single process may have multiple threads of control.
[[09 - threads#multithreading]]
## openMP
*openMP* provides a higher abstraction interface. it is more portable than pthreads as it can be run on POSIX and non-POSIX system
- on POSIX systems, it is implemented on top of pthreads, on non-POSIX systems it is implemented on top of some other abstraction !
>[!info] POSIX
>*POSIX* (*portable operating system interface*) are APIs made for software compatibility between variants of unix systems and other operating systems. 

## pthreads
*pthreads* provides you with much more fine-grained control (the usual ease-of-use / performance tradeoff !)

>[!warning] while possible, it is not recommended to mix openMP and pthreads in the same code .

### multithreading in MPI
## `MPU_Init_thread()`
`MPI_Init_thread` is a function that initializes the MPI enviroment like `MPI_Init`, but also requests a certain level of *thread support* from the MPI library
- must be used when multithreading !
>[!syntax]
>```c
>int MPI_Init_thread(int *argc, char ***argv, int required, int *provided);
>```
- `required`,  can be chosen between the threading levels below
- `provided` is an output value that tells the provided threading level. if the threading level provided is less than the one required, we must do smn cuz the communication may not be thread-safe as intented !

### threading levels
`MPI_THREAD_SINGLE` → rank that calls the function is not allowed to use threads (which is basically equivalent to calling `MPI_Init`)
`MPI_THREAD_FUNNELED` → rank can be multi-threaded but only the main thread may call MPI functions. ideal for fork-join parallelism such as used in `#pragma omp parallel`, where all MPI calls are outside the openMP regions
`MPI_THREAD_SERIALIZED` → rank can be multi-threaded but only one thread at a time may call MPI functions. the rank must ensure that MPI is used in a thread-safe way. one approach is to ensure that MPI usage is mutally excluded by all the threads
`MPI_THREAD_MULTIPLE` → rank can be multi-threaded and any thread may call MPI functions. *the MPI library ensures that this access is safe across threads*. note that this makes all MPI operations less efficient, even if only one thread makes MPI calls, so should be used only when necessary
>[!warning] not all the threading levels are supported by all the MPI implementations

>[!info]- representation of threading levels
single:
![[Pasted image 20251103180811.png]]
>
>funneled:
![[Pasted image 20251103180843.png]]
>
>serialized:
![[Pasted image 20251103180905.png]]
>
>multiple:
![[Pasted image 20251103180934.png]]

## openMP + MPI
the safest and easiest threading level to use when combining openMP and MPI is `MPI_THREAD_FUNNELED`, as it fits nicely with most openMP models, 
>[!info] MPI thread binding
MPI maps each process on a core. thus, all the threads created by that process will run on the same core. to inhibit this functionality, the `--bin-to-none` clause is necessary

[[https://hpc-wiki.info/hpc/Gprof_Tutorial|gprof]]
## thread-safety
a block of code is *thread-safe* if it can be simultaneously executed by multiple threads without causing problems
- many C library functions are not thread-safe ! (e.g. `random()`, `localtime()`, … )
>[!example] tokenizing a file
we can divide the text in lines, and assign each line to a different thread. each thread can then tokenize the line using `strtok()`
however, because of how `strtok()` works (it takes a pointer as input the first time. after the first time it takes `NULL` as input, because it returns succesive tokens taken from the cached pointer), and because the cached string is shared, the `strtok()` function is not thread safe
>
>famo che ci capiamo

in some cases, the C standard specifies alternate, thread-safe versions of a function (e.g. `strtok_r()`), called *re-entrant* functions.
- in principle, re-entrant != thread-safe, but they are often also thread safe.
