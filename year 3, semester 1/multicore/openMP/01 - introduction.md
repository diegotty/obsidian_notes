---
related to: "[[04 - processes and threads]]"
created: 2025-11-22, 18:09
updated: 2025-12-03T12:36
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

## `for` clause
the `for` clause forks a team of threads to execute following structure block, which must be a for loop.
with this clause, the for loop is parallelized by dividing the iterations of the loop among the threads
```c
h = (b - a)/n;
approx = (f(a) + f(b)) / 2.0;
# pragma omp parallel for num_threads(thread_count) reduction(+: approx)
for (i = 1; i <= n - 1; i++)
	approx += f(a + i*h);
approx = h*approx;
```

>[!info] legal forms for parallelizable `for` statements
the for loop that follows the `for` clause must be in one of the following legal forms, so that the runtime system can determine the number of iterations prior to the execution of the loop
![[Pasted image 20251123144719.png]]
also:
>- the variable `index` must have interger or pointer type
>- the espressions `start`, `end`, and `incr` must have a compatible type
>	- e.g. if `index` is a pointer, then `incr` must have integer type (?)
>- the expressions `start`, `end` and `incr` must not change during the execution of the loop !!!!
>- during execution of the loop, the variable `index` can only be modified by the *increment expression* in the for statement

>[!info] rule of thumb
as a rule of thumb, the iterations must be independent and the number of iterations must be determined before the loop starts, and control statements that prevent these rules typically make for looops unparallellizable
>
the goal of the loop is to *complete* the iterations, not to immediately crash the program based on a condition in an arbitrary iteration !

>[!example]- examples of parallelizeable for loops
.```c
.for (i = 0; i < n; i++){
.	if(...) break; //cannot be parallelized
.}
.
.for (i = 0; i < n; i++){
.	if(...) return 1; //cannot be parallelized
.}
.
.for (i = 0; i < n; i++){
.	if(...) exti(); //can be parallelized (shouldn't, however)
.}
.
.for (i = 0; i < n; i++){
.	if(...) i++; //cannot be parallelized
.}
.```

## odd-even sort example
>[!example]- example
this code forks/joins new threads every time the `parallel for` is called (actually, it depends on the implementation but you get the point)
>- if it does so, we would have some overhead !
>```c
>
>for (phase = 0; phase < n; phase++){
>	if(phase  % 2 == 0){
>		# pragma omp parallel for num_threads(thread_count) default(none) shared(a, n) private(i, tmp)
>		for(i = 1; i < n; i += 2){
>			if(a[i-1] > a[i]){
>				tmp = a[i-1];
>				a[i-1] = a[i];
>				a[i] = tmp;
>			}
>		}
>	}else{
>		# pragma omp parallel for num_threads(thread_count) default(none) shared(a, n) private(i, tmp)
>		for(i = 1; i < n; i += 2){
>			if(a[i-1] > a[i]){
>				tmp = a[i+1];
>				a[i+1] = a[i];
>				a[i] = tmp;
>			}
>		}
>	}
>}
>```
>
>we can create the threads at the beginning ! (only in this program though !)
>```c
># pragma omp parallel num_threads(thread_count) default(none) shared(a, n) private(i, tmp, phase)
>
>for (phase = 0; phase < n; phase++){
>	if(phase  % 2 == 0){
>		# pragma omp for
>		for(i = 1; i < n; i += 2){
>			if(a[i-1] > a[i]){
>				tmp = a[i-1];
>				a[i-1] = a[i];
>				a[i] = tmp;
>			}
>		}
>	}else{
>		# pragma omp for
>		for(i = 1; i < n; i += 2){
>			if(a[i-1] > a[i]){
>				tmp = a[i+1];
>				a[i+1] = a[i];
>				a[i] = tmp;
>			}
>		}
>	}
>}
>```

>[!info] reusing the same threads provide faster execution times !
![[Pasted image 20251123145805.png]]

## nested for loops
>[!example] example
if we have nested for loops, it is often enough to simply parallelize the outermost loop
![[Pasted image 20251123152117.png]]
>
>but sometimes, the outermost loop is so short that not all threads are utilized, so we could try to parallelize the inner loop, but there is no guarantee that the thread utilization will be better
![[Pasted image 20251123152420.png]]

>[!info] the solution
the correct solution is to *collapse the nested loop into one loop*.
we can do this manually:
![[Pasted image 20251123152554.png]]
>
or we can ask openMP to do it for us, with the clause `collapse(n_of_nested_loops)`
![[Pasted image 20251123152608.png]]

>[!warning] nested parallelism
nested parallelism is disabled by openMP by default ! (nested for clauses get ignored)
![[Pasted image 20251123152650.png]]

## scheduling loops
the `schedule` clause is used to handle how the threads divide the iterations of a loop
>[!syntax] syntax
>```c
schedule(type, chunksize)
>```

- `type` can be:
	- `static`: the iterations can be assigned to the threads before the loop is executed (by the programmer)
	- `dynamic` or `guided`: the iterations are assigned to the threads while the loop is executing
	- `auto`: the compiler and/or the run-time system determine the schedule
	- `runtime`: the schedule is determined at run-time
>[!info] default vs cyclic partitioning
![[Pasted image 20251203121551.png]]

>[!example] scheudling loops
>- sequential program:
>```c
>sum = 0.0;
>for (i = 0; i <= n; i++){
>	su += f(i);
>}
>```
>- default schedule:
>```c
>sum = 0.0;
># pragma omp parallel for num_threads(thread_count) reduction(+ : sum)
>for (i = 0; i <= n; i++){
>	sum += f(i);
>}
>```
>
>- cyclic schedule:
>```c
>sum = 0.0;
># pragma omp parallel for num_threads(thread_count) reduction(+ : sum) schedule(static, 1)
>for (i = 0; i <= n; i++){
>	sum += f(i);
>}
>```

| #threads | 1    | 2 (default scheduling) | 2 (cyclic scheduling) |
| -------- | ---- | ---------------------- | --------------------- |
| runtime  | 3.67 | 2.76                   | 1.84                  |
| speedup  | 1    | 1.33                   | 1.99                  |
### `static`
the iterations can be assigned to the threads before the loop is executed (by the programmer)
>[!example] `static` schedule type
twelve iterations, three threads
>
>`schedule(static, 1)`
>- thread 0: 0,3,6,9
>- thread 1: 1,4,7,10
>- thread 2: 2,5,8,11
>
`schedule(static, 2)`
>- thread 0: 0,1,6,7
>- thread 1: 2,3,8,9
>- thread 2: 4,5,10,11
>
`schedule(static, 4)`
>- thread 0: 0,1,2,3
>- thread 1: 4,5,6,7
>- thread 2: 8,9,10,11

### `dynamic`
the iterations are assigned to the threads while the loop is executing.
with this type, the iterations are also broken up into chunks of `chunksize` consecutive iterations. each thread executes a chunk, and when a thread finishes a chunk, it requests another one from the run-time system. this continues until all the iterations are completed.
this guarantess a *better load balancing*, but higher overhead to schedule che chunks (this however can be tuned through the chunksize)
- if omitted, the `chunksize` of 1 is used
### `guided`
the iterations are assigned to the threads while the loop is executing.
the difference between the `guided` type and the `static` is that *as chunks are completed, the size of the new chunks decreases*
- this avoids stragglers (threads that fall behind bc they are moving more slowly)
in particular, the chunks have size `num_iterations`/`num_threads`, where `num_iterations` is the *number of iteraions left*
- if omitted, the `chunksize` of 1 is used
>[!example] assignment of trapeoidal rule iterations 1-9999 using a guided schedule with two threads
![[Pasted image 20251203114733.png]]

### `runtime`
the system uses a environment variable `OMP_SCHEDULE` to determine at run-time how schedule the loop:
it can take on any of the values that can be used for a static, dynamic or guided schedule
- useful for *benchmarking and tuning* because you can test different scheduling options without recompiling the code everytime
>[!syntax] syntax
>```c
>$ export OMP_SCHEDULE = "static, 1"
>```
>
>you can also set it through the function 
>```c
>omp_set_schedule(omp_sched_t kind, int chunk_size);
>```

>[!info] how to select a schedule option
>- `static`: if iterations are homogeneous (the execution time required for each iteration is roughly the same)
`dynamic/guided`: if execution cost varies due to input data, conditional logic or cache effects
>
>the best practice is to use performance tools to measure the runtime for different schedule options *on your target hardware*

## synchronization constructs
## `master, single`
both force the execution of the following structured block by  a *single thread*
- `single`, however, *implies* a `barrier` on exit from the block
- `master` guarantees that the block is executed by the *master thread*
### `barrier`
the `barrier` directive blocks the threads that arrive to it until all team threads reach that point