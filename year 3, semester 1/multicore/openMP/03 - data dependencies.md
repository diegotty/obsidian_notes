---
related to:
created: 2025-12-03, 14:53
updated: 2025-12-06T16:38
completed: false
---
openMP compilers don’t check for dependencies among iterations in a loop that is being parallelized with a `parallel for`
a *data dependency* exists when the execution order of two different iterations accessing the *same memory location* must be preserved to get the correct result
- in general, these cannot be correctly parallelized by openMP.
## dependence types
data dependencies are classified based on the interaction between a *write* operation and a *read* operation across different iterations !
### read after write
*read after write* (*RAW*), also called *flow dependence* happens when an iteration $j$ must read a value that was written by iteration $i$, and $i$ must execute before $j$
- if $j$ executes before $i$, $j$ reads the old (and incorrect) value of the variable
>[!example] RAW dependence example
>```c
>double v = start;
>double sum = 0;
>for(i = 0; i < N; i++){

>}
>```
>the write is in iteration $i$, and the read is in iteration $i+1$. this is a loop-carried flow dependence. 
>the data flows from the write to the read from the end of one iteration to the start of the next !
### write after read
*write after read* (*WAR*), also called *anti-dependence* happens when an interation $j$ must write a value to a location that was read by iteration $i$, and $i$ must read the old value before $j$ overwrites it
- if $j$ executes before $i$, $i$ reads the new (and incorrect value of the variable)
## data dependency resolution
### reduction
```c
double v = start;
double sum = 0;
for(i = 0; i < N; i++){
	sum = sum + f(v); //read
	v = v + step; //write
}
```

### loop skewing
### partial parallelization
### refactoring
### fissioning
### algorithm change
*if everything else fails, switching the algorithm may be the answer*
literally change the algoritm
>[!example] fibonacci sequence
the following algorithm cannot be parallelized
```c
for(int i = 2; i < N; i++){
	int x = F[i-2];
	int y = F[i-1];
	F[i] = x + y
}
```

however, fibonacci’s sequence is also ca through binet’s formula:
$$
$$
## antidependence removal
## output dependence removal


ip submitter :  `sh desensi@192.168.0.102`

slurm

`salloc -N 4 -ntasks-per-node=32`
`N`: numero di nodi
`ntasks-per-node=32` (core per nodo)
`--time=00:00:00` ore minuti secondi


`scontrol show job jobid`