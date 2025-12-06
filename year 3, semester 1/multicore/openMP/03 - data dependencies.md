---
related to:
created: 2025-12-03, 14:53
updated: 2025-12-06T15:48
completed: false
---
openMP compilers don’t check for dependencies among iterations in a loop that is being parallelized with a `parallel for`
a *data dependency* exists when the execution order of two different iterations accessing the *same memory location* must be preserved to get the correct result
- in general, these cannot be correctly parallelized by openMP.
## dependence types
data dependencies are classified based on the interatction between a *write* operation and a *read* operation across different iterations
### write after read
*write after read* (*WAR*), also called *anti-dependence* happens when an interation $j$ must write a value to a location that was read by iteration
## reduction
## loop skewing
## partial parallelization
## refactoring
## fissioning
## algorithm change
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