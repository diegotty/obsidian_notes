---
related to: "[[04 - processes and threads]]"
created: 2025-11-22, 18:09
updated: 2025-11-23T11:06
completed: false
---
# openMP
*OpenMP* is an API for shared-memory parallel programming. it aims to decompose a sequential program into components that can be executed in parallel.
- the system is viewed as a collection of cores or CPU’s, all of which have access to main memory.
- MP stands for multiprocessing

openMP allows for *incremental conversion* of the sequential programs, by targeting hotspots (instead of re-writing the entire program) and adding directives to such code-blocks
it also relies on *compiler directives*: special, non-standard language constructs that are ignored by a standard compiler but recognized and interpreted by an openMP-aware compiler
- an example of compiler directives are *pragmas*

openMP programs are [[02 - parallel design patterns#GSLP|globally sequential, locally parallel]] (and it makes complete sense)

## pragmas
the most basic parallel directive is 
```c
# pragma omp parallel
```

>[!example] example
>```c
>#include <stdio.h>
>#include <stdlib.h>
>#include <omp.h>
>
>void Hello(void);
>
>int main(int argc, char* argv[]) {
>	// get number of threads from command line
>	int thread_count = strtol(argv[1], NULL, 10);
>	
>	#pragma omp parallel num_threads(thread_count)
>	Hello();
>	
>	return 0;
>}
>
>void Hello(void) {
>	int my_rank = omp_get_thread_num(); // my thread number
>	int thread_count = omp_get_num_threads(); // total number of threads
>	
>	printf("Hello from the thread %d\n", my_rank, thread_count)
>}
>```
the code runs the `Hello()` function with `thread_count` threads.

>[!warning] by default, `thread_count` is the total number of available cores
## thread 
openMP gives us severl ways to control the number of threads that will be created and used to execute the code
- *universally*: via the `OMP_NUM_THREADS` environmental variable
- *program level*: via the `omp_set_num_threads()` function, outside an openMP construct
- *pragma level*: via the `num_threads` clause
the hierarchy of relevance follows the order

