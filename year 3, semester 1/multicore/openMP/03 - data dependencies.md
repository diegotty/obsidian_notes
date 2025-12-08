---
related to:
created: 2025-12-03, 14:53
updated: 2025-12-08T11:27
completed: false
---
openMP compilers don’t check for dependencies among iterations in a loop that is being parallelized with a `parallel for`
a *data dependency* exists when the execution order of two different instructions accessing the *same memory location* must be preserved to get the correct result.

there many types of data dependencies, and they are safe if they are *intra-iteration*: the instructions that cause the dependence are within the same block of code and the single iteration.
however, data dependencies become hazardous when they become *inter-iteration*: the dependency happens across different iterations of a loop. this type of dependency is called *loop-carried*, and they in general cannot be correctly parallelized by openMP
## dependence types
data dependencies are classified based on the interaction between a *write* operation and a *read* operation across different iterations !
>[!info] dependence types
>```c
>for(i = ....){
>	S1: operate on a memory location x
>	...
>	S2: operate on a memory location x
>}
>```
>S1 and S2 can either be *write* or *read* operations. their combinations (4 possible ones) generates different data dependencies, and can be *loop-carried dependencies*
### read after write
*read after write* (*RAW*), also called *flow dependence* happens when a *read* operation necessarily needs to happen after a *write* operation as otherwise it would read a wrong value
>[!example] RAW example
>```c
>x = 10; //S1
>y = 2 * x + 5; //S2
>```
S1 must be executed before S2

a RAW loop-carried dependence happens when an iteration $j$ must read a value that was written by iteration $i$, and $i$ must execute before $j$
- if $j$ executes before $i$, $j$ reads the old (and incorrect) value of the variable
>[!example] loop-carried RAW example
>```c
>double v = start;
>double sum = 0;
>for(i = 0; i < N; i++){
>	A[i] = B[i] + 1;
>	B[i+1] = A[i];
>}
>```
>the write is in iteration $i$, and the read is in iteration $i+1$. this is a loop-carried flow dependence. 
>the data flows from the write to the read from the end of one iteration to the start of the next !
### write after read
*write after read* (*WAR*), also called *anti-dependence* happens when a *read* operation needs to happen before a *write* operation, as otherwise it would read the wrong value

>[!example] WAR example
>```c
>y = x + 3; //S1
>x++;       //S2
>```

a loop-carried RAW happens when an interation $j$ must write a value to a location that was read by iteration $i$, and $i$ must read the old value before $j$ overwrites it
- if $j$ executes before $i$, $i$ reads the new (and incorrect value of the variable)
### write after write
 *write after write* (*WAW*) happens when a *write* operations needs to happen after a *write* operation, as otherwise things would go to shit
>[!example] WAW example
>```c
>x = 10;
>x = x + c;
>```

### read after read
not an actual dependence we will gloss over this we dont care
>[!example] RAR example
>```c
>y = x + c;
> z = 2 * x + 1;
>```
## data dependency resolution
there are many possible techniques to resolve the different data dependencies. we focus on the *RAW*  dependence, and illustrate 6 techniques to remove it and therefore correctly parallelize the for loop
### reduction variable and induction variable fix
*reduction variable*: a variable used to accumulate a value across all iterations, using an associative operation
*induction variable*: a variable whose value is defined as a product of the loop variable (in this case, `v = v + step` == `v = start + i*step`)

>[!example] example
>```c
>double v = start;
>double sum = 0;
>for(i = 0; i < N; i++){
>	sum = sum + f(v); //S1 (read)
>	v = v + step; //S2 (write)
>}
>```

this example raises 3 data dependencies:
- `RAW(S1)` caused by the *reduction variable* `sum`, as the iteration $i+1$ reads the value of `sum` that got written in iteration $i$
	- this is a loop-carried dependence !
- `RAW(S2)` caused by the *induction variable* `v`, for the same reason of `RAW(S1)`
	- this is a loop-carried dependence !
- `RAW(S2 -> S1)` caused by the induction variable `v`: the iteration $i+1$ reads in `S1` the value of `v` that was written by `S2` in the iteration $i$.
	- this is a loop-carried dependence !

>[!info] the fix
the following change to the loop structure removes `RAW(S2)` (as `v` is calculated “from scratch” every iteration), and removes `RAW(S2->S1)`, as it changes to a `RAW(S1->S2)` that is intra-iteration thus completely safe
>```c
>double v;
>double sum = 0;
>for(int i = 0; i < N; i++){
>	v = start + i*step;
>	sum = sum + f(v);
>}
>```
>
to remove `RAW(S1)`, we use the `reduction` directive, executing the reduction in a parallel-friendly way using an openMP construct
>- we can now parallelize the loop as the inter-iteration dependencies have been fixed !
>```c
>double v;
>double sum = 0;
>#pragma omp parallel for reduction(+ : sum) private(v)
>for(int i = 0; i < N; i++){
>	v = start + i*step;
>	sum = sum + f(v);
>}
>```
### loop skewing
this technique involves the rearrangement of the loop body statements
>[!example] example
the following code has a `RAW(S2->S1)` on `x`, as iteration $i+1$ reads `x[i]`, which is written in iteration $i$
>- this is a loop-carried dependence !
>```c
>for(int i = 1; i < N; i++){
>	y[i] = f(x[i-1]);       //S1
>	x[i] = f(x[i] + c[i]);  //S2
>}
>```
>>[!info] fix
>the solution is to make sure that the statements that read the calculated values that cause the `RAW` use values generated *during the same iteration*
>>```c
>>y[1] = f(x[0]);
>>for(int i = 1; i < N; i++){
>>	x[i] = x[i] + c[i];
>>	y[i+1] = f(x[i]);
>>}
>>x[N-1] = x[N-1] + c[N-1];
>>```
>>to do loop skewing, *unroll the loop* and see the repetition pattern !!
>>![[Pasted image 20251206173054.png]]
### partial parallelization
partial parallelization is achieved by analyzing the *interation space dependency graph* (*ISDG*), which is made up of:
- nodes that represent a single execution of the loop body
- edges that represent dependencies
>[!example] example
there is a `RAW(S1)` dependence
>- this is a loop-carried dependence !
>```c
>for (int i = 1; i < N; i++){
>	for(int j = 1; j < M; j++){
>		data[i][j] = data[i-1][j] + data[i-1][j-1]; //S1
>	}
>}
>```
![[Pasted image 20251206173706.png]]
the graph shows that there are no dependencies (edges) between nodes on the same row, thus making it possible to parallelize the j-loop, but not both
>>[!info] fix
>>```c
>>for (int i = 1; i < N; i++){
>>#pragma omp parallel for
>>	for(int j = 1; j < M; j++){
>>		data[i][j] = data[i-1][j] + data[i-1][j-1];
>>	}
>>}
>>```
>we ensure that a iteration will never look up a value that has not been already calculated !
### refactoring
refactoring consists in rewriting the loop(s) so that parallelism can be exposed

>[!example] example
here we have a `RAW(S1)` dependence
>- this is a loop-carried dependence ! 
>```c
>for (int i = 1; i < N; i++){
>	for (int j = 1; j < M; j++){
>		data[i][j] = data[i-1][j] + data[i][j-1] + daa[i-1][j-1]; //S1
>	}
>}
>```
the ISDG clearly shows that the loop is not parallelizable in rows unlike the last example, however diagonal sests can be executed in parallel, as there are no dependencies between nodes in the same diagonal set
![[Pasted image 20251208103749.png]]
>>[!info] fix
>this adjustment requires a change of the loop variables but allows parallelism !
>>```c
>>// intuition
>>for (wave = 0. wave < num_waves; wave++){
>>	diag = F(wave);
>>	for (k = 0; k < diag; k++){
>>		int i = get_i(diag, k);
>>		int j = get_j(diag, k);
>>		data[i][j] = data[i-1][j] + data[i][j-1] + data[i-1][j-1];
>>	}
>>}
>>// ummm sure
>>```
### fissioning
fissioning involves breaking the loop apart into two parts: a *sequential* part and a *parallelizable* part

>[!example] example
there is a `RAW(S1)` dependence
>- this is a loop-carried dependence !
>```c
>s = b[0];
>for(int i = 1; i < N; i++){
>	a[i]= a[i] + a[i-1]; // S1
>	s = s + b[i];
>}
>```

>[!info] fix
the dependence doesnt exist anymore as the code is executed sequentially by one single thread
>```c
>for (int i = 1; i < N; i++){
>	a[i] = a[i] + a[i-1];
>}
>#pragma omp parallel for reduction(+ : s)
>for (int i = 1; i < N; i++){
>	s = s + b[i];
>}
>```
### algorithm change
*if everything else fails, switching the algorithm may be the answer*
literally change the algoritm
>[!example] example (fibonacci sequence)
the following algorithm cannot be parallelized
>```c
>for(int i = 2; i < N; i++){
>	int x = F[i-2];
>	int y = F[i-1];
>	F[i] = x + y
>}
>```
>>[!info] fix
>however, fibonacci’s sequence is also calculated through binet’s formula:
>>$$
>>F_{n} = \varphi^n - \frac{(1-\varphi)^n}{\sqrt{ 5 }}
>>$$
## antidependence removal
>[!example] example
there is a `WAR(S1)` dependence, as `a[i]` is written in the iteration $i$ after being read in the iteration $i-1$, thus maintaining this order is integral
>- this is a loop-carried dependence !
>```c
>for(int i = 0; i < N; i++){
>	a[i] = a[i+1] + c; //S1
>}
>```
>>[!info] fix
>the simple solution is to make a copy of the array before starting to modify it
>>- this introduces a space tradeoff that needs to be carefully evaluated !
>>```c
>>for (int i = 0; i < N-1; i++){
>>	a2[i] = a[i+1];
>>	
>>	#pragma omp parallel
>>	for(int i = 0; i < N-1; i++){
>>		a[i] = a2[i] + c;
>>	}
>>}
>>```
## output dependence removal
>[!example] example
there is `WAW(S2)`because we need to (only, in this case, )ensure that the value written in `d` is `fabs(y[N-1])`.
there is also `RAR(S1)` but that is not an actual dependence
>```c
>for (int i = 0; i < N; i++){
>	y[i] = a * x[i] + c; //S1
>	d = fabs(y[i]); //S2
>}
>```
>>[!info] fix
>deep this:
>>```c
>>#pragma omp parallel for shared(a, c) lastprivate(d)
>>for (int i = 0; i < N; i++){
>>	y[i] = a * x[i] + c; //S1
>>	d = fabs(y[i]); //S2
>>}
>>```

ip submitter :  `sh desensi@192.168.0.102`

slurm

`salloc -N 4 -ntasks-per-node=32`
`N`: numero di nodi
`ntasks-per-node=32` (core per nodo)
`--time=00:00:00` ore minuti secondi


`scontrol show job jobid`