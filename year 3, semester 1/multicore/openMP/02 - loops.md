---
related to:
created: 2025-12-06, 13:50
updated: 2025-12-06T13:53
completed: false
---
# in
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