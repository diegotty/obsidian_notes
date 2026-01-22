---
related to: "[[04 - processes and threads]]"
created: 2025-11-22, 18:09
updated: 2026-01-16T05:49
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
openMP is based on pragmas (that start with `#pragma omp`) that instruct the compiler to generate the necessary multithreaded code

>[!syntax] syntax
the most basic parallel directive is 
>```c
># pragma omp parallel
>```

we can attach *clauses* to primary parallel directives that specify the details, restrictions and behaviours of the parallel exeuction.
they generally fall into 4 main categories:
- data environment clauses (specify the scope/visibility of variables within the parallel region)
- synchronization reduction clauses (control the flow of execution of parallel blocks)
- work sharing/scheduling clauses (define how iterations of a loop or tasks are distributed among the threads)
- runtime thread management clauses (control the number of threads, or how threads are bound to cores)


>[!warning] while the variables outside the parallel block are shared across all threads, threads will each have a private copy of variables declared inside a `#pragma`

>[!info] parallel construct
![[Pasted image 20251123111538.png]]

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
>	#pragma omp parallel num_threads(thread_count) //stating the number of threads through a clause
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

>[!info] running openMP programs
>```sh
>gcc -g -Wall -fopenmp -o omp_hello omp_hello.c #compiling
>./omp_hello 4 #running with 4 threads
>```
## thread team size control
openMP gives us severl ways to control the number of threads that will be created and used to execute the code (such collection of threads that execute the parallel block is called *team*)
- *universally*: via the `OMP_NUM_THREADS` environmental variable
- *program level*: via the `omp_set_num_threads()` function, outside an openMP construct
- *pragma level*: via the `num_threads` clause (thread magament clause)
the hierarchy of relevance follows the order

just like in MPI, there are utility functions:
- `omp_get_num_threads` returns the active threads in a parallel region
- `omp_get_thread_num` returns the id of the calling thread (similar to the rank in MPI)

like we would expect, openMP waits for all the threads to finish their parallel operations before moving forward the program (after a parallel block is completed, there is an implicit barrier)
>[!info]
>there may be system-defined limitations on the number of threads that a program can start, so the openMP standard doesn’t guarantee that a program will start with `thread_count` theads (if specified at the pragma level)
>- however, this is very rare

## openMP support
to prevent errors when compiling openMP code on compilers that don’t support it, we must use C standard preprocessing directives to check for a macro:
```c
#ifdef _OPENMP
#include <omp.h>
#endif

// ...

#ifdef _OPENMP
int my_rank = omp_get_thread_num();
int thread_count = omp_get_num_threads();
#else
int my_rank = 0;
int thread_count = 1;
#endif
```

## trapezoid example
>[!example] example
we use trapezoids to calculate the defined integral of a function like we did in [[02 - parallel design patterns#trapezoid example|MPI]] !
![[Pasted image 20251123112403.png]]
## `critical` and `atomic` clauses

to access a shared variable like `global_variable` in the next snippet, we need to ensure mutual exclusion to it. we do so by adding the `critical` clause, which guarantees that only one thread at a time can execute the critical region, preventing race conditions
if supported, the `atomic` clause ensures that a specific memory operation is performed as a single, indivisible action at the hardware level (a light-weight `critical`).
- it is optimized for single-statement memory operations, thus results in better performance. doesn’t work well for complex logics or multiple lines of code !
>[!example]- solution
grz flavio
>```c
>#include <stdio.h>
>#include <stdlib.h>
>#include <omp.h>
>
>void Trap(double a, double b, int n, double* global_result_p);
>
>int main(int argc, char* argvp[]) {
>	double global_result = 0.0; // store result in global_result
>	double a, b;                // left and right endpoints
>	int    n;                   // total number of trapezoids
>	int    thread_count;
>	
>	thread_count = strtol(argv[1], NULL, 10);
>	printf("Enter a, b, and n\n")
>	scanf("%lf %lf %d", &a, &b, &n);
>	
>	#pragma omp parallel num_threads(thread_count)
>	Trap(a, b, n, &global_result)
>	
>	printf("With n = %d trapezoids, our estimate\n", n);
>	printf("of the integral from %f to %f =%.14e\n", a, b, global_result);
>	
>	return 0;
>}
>
>void Trap(double a, double b, int n, double* global_result_p) {
>	double h, x, my_result;
>	double local_a, local_b;
>	int    i, local_n;
>	int    my_rank = omp_get_thread_num();
>	int    thread_count = omp_get_num_threads();
>	
>	h = (b - a) / n;
>	local_n = n / thread_count;
>	local_a = a + my_rank * local_n * h;
>	local_b = local_a + local_n * h;
>	
>	my_result = (f(local_a) + f(local_b)) / 2.0;
>	for (i = 1; i <= local_n - 1; i++) {
>		x = local_a + i * h;
>		my_result += f(x);
>	}
>	
>	my_result = my_result * h;
>	
>	# pragma omp critical
>	*global_result_p += my_result;
>}
>```
### named critical sections
openMP provides the option of adding a name to a critical directive. this way, two blocks protected with `critical` directives can be executed simoultaneously (as it is like acting on two different locks)
- these must be set up at compile time
>[!syntax] syntax
>```c
># pragma omp critical(name)
>```
## locks
however, what if we want to have multiple locks/critical sections but we do not know how many at compile time (e.g., a linked list with a lock for each node)
>[!example] locks !
>```c
>omp_lock_t writelock;
>omp_init_lock(&writelock);
>
>#pragma omp parallel for
>for(i = 0; i < x; i++){
>	// some stuff
>	omp_set_lock(&writelock);
>	// one thread at a time stuff
>	omp_unset_lock(&writelock);
>	// some other stuff
>}
>omp_destroy_lock(&writelock);
>```

>[!info] caveats
>- while the `atomic` directive has the potential to be the fastest method of obtaining mutual exclusion, some `atomic` clause implementations might enforce mutual exclusion across *all `atomic` directives in the program*, even between ones who do not share the same critical section
>- the use of locks should be probablly reserved for situations in which mutual exclusion is needed for a data structure rather than a block of code
>- you shouldn’t mix the different types of mutual exclusions for a single critical section
>- there is no guarantee of fairness in mutual exclusion constructs (the waiting queue is unordered)
>- it can be dangerous to nest mutual exclusion constructs
## scope
in openMP, the *scope* of a variable refers to the set of threads that can access the variable in a parallel block (so not where, but by who). they are:
- `shared`: a variable that can be accessed by all the threads in the team (default scope for variables declared before a parallel block)
- `private`: a variable that can only be accessed by a single thread, enforced by creating a separate copy of the variable for each thread in the team. these variables are *not initialized*, so one should not exepct to get the value of the variable declared outside the parallel construct
>[!example]- private initilization example
>```c
>int x = 5;
>#pragma omp parallel private(x)
>{
>x = x+1; // dangerous ! x is not initialized
>}
>```
#### `default` clause
it lets the programmer specify the scope of each variable in a block. the compiler will enforce this requirement for each variable we use inside the block that has been declared outside the block
>[!syntax] syntax
>```c
># pragma omp parallel default(none)
>```

### `firstprivate` and `lastprivate`
these scope-modifying clauses substitute and modify the behaviour of the private clause:
- `firstprivate`: behaves the same was as the private clause, but the private variable copies *are initialized to the value of the “outside” object*
- `lastprivate`: behaves the same way as the private clause, but the thread finishing *the last iteration of the sequential block* copies the value of its object to the “outside” object

### `threadprivate` clause
we could also need to declare private variables that persit outside of a parallel section, which won’t happen when using the clauses shown above
-  creates a thread-specific, *persistent* storage (for the duration of the program), for global data.
	- the variable needs to be `global/static` in C, or a static class member in C++
the `copyin` is used in conjunction with the `threadprivate` (mandatory) clause to initialize the private copies of a variable from the master (thread `0`, which runs the sequential code) thread’s variable

>[!example] example
>```c
>int total = 0; // Shared variable 
>int N = 1000; // Shared variable 
>// Using default(none) forces the programmer to explicitly state 
>// the scope of 'total', 'N', and 'i'. 
>#pragma omp parallel for default(none) private(i) shared(total, N)
>	reduction(+:total) 
>for (i = 0; i < N; i++){ 
>total += i; // Error-free because 'total' is in reduction, 'i' and 'N' are handled }
>}
>```
## `reduction` clause
openMP provides a native way to accumulate a result by a thread team, just like MPI provides `MPI_Reduce()`
a reduction is a computation that repeatedly applies the same reduction operartor (a binary operation) to a sequence of operands (threads) in order to get a single result. it does so by storing all of the intermediate results of the reduction in the same variable, the reduction variable

>[!syntax] syntax
the syntax to add a reduction clause is
>```c
>reduction(<operator>: <variable_list>)
>```

>[!info] `reduction` flow
>1. the original shared value given in the `<variable_list>` is temporarily put aside
>2. the openMP runtime creates a private copy of that variable for each thread in the team (initialized to the *identity value* for the given operator (multiplication: `1`, sum: `0`, …))
>3. each thread calculates its partial result using its private copy of the variable
>4. all the values of the private copies are collected
>5. the reduction operator is applied to all of the private variables
>6. the redution operator is applied to the result point 5 and the original shared value of point 1 
>
(this way, the original value is preserved and included in the final result)

>[!example] adding a reduction to the trapezoid example
>```c
># pragma omp parallel num_threads(thread_count)
>	reduction(+: global_result)
>global_result += Local_trap(double a, double b, int n);
>```
if we do not specify the reduction clause, the line of code would be a race condition !