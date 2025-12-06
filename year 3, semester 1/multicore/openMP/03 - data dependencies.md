---
related to:
created: 2025-12-03, 14:53
updated: 2025-12-06T15:33
completed: false
---
openMP compilers don’t check for dependencies among iterations in a loop that is being parallelized with a `parallel for`
a loop in which the results of one or more iterations depend on other iterations cannot is a *loop-carried dependence*
- in general, these cannot be correctly parallelized by openMP.
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