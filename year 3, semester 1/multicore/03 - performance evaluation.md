---
related to: "[[02 - parallel design patterns]]"
created: 2025-11-03T08:26
updated: 2026-01-12T20:23
completed: false
---
# performance evaluation
we are interested in calculating the time elapsed since the start of the program until the end of it, which concides with the end of the last process. we then must report the *maximum runtime across the rank* as the result of a run !
>[!info] finishing at a different time
![[Pasted image 20251103084926.png]]
rank 0 is going to finish much later than rank 7, so we should report the maximum time across the ranks

however, it is not guaranteed that every rank is going to start at the same time. if not, the time we report might be longer because someone started later than someone else.
- to ensure all processes start at the same time, we use [[performance evaluation#`MPI_Barrier`|MPI_Barrier()]]
## `MPI_Barrier`
`MPI_Barrier` is a collective that *enforces synchronization* across all processes in a communicator. it acts like a wall that all participating processes must reach before any of them can proceed !
- when the first process reaches the barrier, it halts execution and waits until every process in the comm has also called the barrier collective
this function is *not a guarantee, but a reasonable approximation* of synchronization !

## reporting performance
we must note that performance data is *non deterministic*: 100 runs of the same application will give 100 different results, as a result of interference from other application and/or the OS for the single compute node and interference on the network across multiple nodes
>[!info] bottlenecks
![[Pasted image 20251103091159.png]]

we *have to run the application multiple times*, and we report the entire distribution of timings
>[!info] graph showing distribution of timings
![[Pasted image 20251103091302.png]]

>[!info] the impact of noise
![[Pasted image 20251103091457.png]]
as the number of GPUs increases, the goodput gets worse. why ? because the more ranks you have, the more likely it is that at least one of them is affected by noise
## expectations
>[!info] run-times of serial and parallel matrix-vector multiplication
![[Pasted image 20251103091942.png]]
the runtime increases with problem size and decreases with the number of processes.
however, we can se that we measure the same runtime when doubling the processes from 8 to 16 in the first column. we must be able to have realistic expectations !

### speedup
ideally, when running with $p$ processes, the program should be $p$ times faster than when running with 1 process. we define:
- $T_{serial}(n)$ as teh time of our *sequential application* on a problem of size $n$ (e.g. the dimension of the matrix)
- $T_{parallel}(n, p)$ the time of our *parallel application* on a problem of size $n$, when running with $p$ processes
- $S(n,p)$ the *speedup* (quantitative measure measuring “absolute” performance improvement) of our parallel application:
$$
S(n, p) = \frac{T_{serial}(n)}{T_{parallel}(n,p)}
$$
ideally, $S(n,p) = p$. in this case, we say our program has a *linear speedup*
>[!warning] we must take the tests on the same type of cores/systems (only CPU cores or only GPU cores)

>[!info] expected speedup
![[Pasted image 20251103092819.png]]
in general, we expect the speedup to get better when increasing the problem size $n$
>
>speedups of parallel matrix-vector multiplication:
![[Pasted image 20251103092916.png]]
### scalability
we must note that $T_{serial}(n)$ is different to $T_{parallel}(n, 1)$, which is the time of our *parallel application* on a problem of size $n$, running with 1 process
- the parallel and sequential implementations might be different, and in general, $T_{parallel}(n, 1) \geq T_{serial}(n)$
the *scalability* (qualitative measure) describes how effectively the speedup is maintained as resources vary
$$
S(n,p) = \frac{T_{parallel(n,1)}}{T_{parallel(n,p)}}
$$
## efficiency
(we call efficiency what is defined as *parallel efficiency*) measures how effectively the *processing resources are utilized*.
$$
E(n,p) = \frac{S(n,p)}{p} = \frac{T_{serial}(n)}{p\times T_{parallel}(n,p)}
$$
ideally, we would like to have $E(n,p) = 1$ (bc we hope for a linerar speedup), however in practice it is $\leq1$, and it gets worse with smaller problems
- an efficiency of 0.8 means that, on average, each processor was actively contributing to the solution 80% of the time it was running
	- meh kind of makes sense ig
>[!info] graph showing efficiency
![[Pasted image 20251103094521.png]]
>
>efficiencies of parallel matrix-vector multiplication
![[Pasted image 20251103095129.png]]

## scaling
*strong* and *weak* scaling are two methods used to evaluate the scalability of a parallel program. they differ on whether the total problem size is kept fixed or scaled along with the processors
- *strong scaling*: the problem size is kept fixed, and the number of processes is increased. if we can keep a high efficiency, our program is *strong-scalable*
- *weak scaling*: the problem size is increased at the same rate at which the number of processes is increased. if we can keep a high efficiency, our program is *weak-scalable*
>[!example]
as we can observe, the program is not strong-scalable but it is weak-scalable
![[Pasted image 20251103095731.png]]
![[Pasted image 20251103095820.png]]

different scalings are needed for different problems and are used to make decisions on resource allocation and code optimization:
- *strong scaling*: evaluating time-critical problems where the size is fixed. if strong scaling drops, adding processes would not be worth it
- *weak scaling*: evaluating ability to handle increasing datasets. if weak scaling holds up, it means the parallel algorithm is well-designed !
## amdahl’s law
we focus on *weak scaling*, where the problem size does not increase:
each program has some part of it which *cannot* be parallelized (e.g. I/O operations, sending/receiving data over the network, …). we calculate this fraction as the *serial fraction*: $1-\alpha$
- with $0 \leq \alpha\leq1$ as the fraction of the program that can be parallelized

*amdahl’s law* says that the speedup is limited by the serial fraction
>[!info] representation
![[Pasted image 20251028171505.png]]
we can divide $p$ by $n$ (by parallelizing it), however we can’t speedup $s$

so we need to re-consider how we think of $T_{parallel}(p)$:
$$
T_{\text{parallel}}(p) = (1-\alpha)T_{\text{serial}}+\alpha \frac{T_{\text{serial}}}{p}
$$
we also need to re-consider the speedup $S(p)$:
$$
S(p) = \frac{T_{\text{serial}}} {(1-\alpha)T_{\text{serial}}+\alpha \frac{T_{\text{serial}}}{p}}
$$

this puts an *upper bound* of the speedup *for any amount of processors*, as
$$
\lim_{ p \to \infty } S(p) = \frac{1}{1-\alpha}
$$
>[!example] example
if $\alpha=0.6$, it means we can expect a speedup of, at most, 2.5
if $\alpha=0.8$, it means we can expect a speedup of, at most, 5
>
>to be able to scale up to 10000, processes, we need to have a $\alpha \geq 0.9999$


>[!info] chart
![[Pasted image 20251028172537.png]]
this chart shows the relationship between $alpha$ and the possible scalability

however, in pratice this could get worse than the hypothesized best case scenario, as with small problem sizes, using more processes creates a lot of overhead 
>[!info] law of diminishing returns in full effect
![[Pasted image 20251103143640.png]]
## gustafson’s law
if we consider *weak scaling*, the parallel fraction increases with the problem size ! also, because the increase in problem size is matched with an increase of processes, the work assigned to each processor remains constant
- the serial time remains constant, because the serial time usually deals with the overall setup and tear-down of the program, not the per-processor work.
- the parallel time increases, as more processes implies more communication and synchronization between them, which increases the overhead. in fact, collective functions get worse in performance the more processes there are inside the communicator
this is also known as *scaled speedup*:
$$
S(n,p) = (1-\alpha) + \alpha p
$$

>[!info] representation
![[Pasted image 20251103143125.png]]

## example: sum between vectors
vector sum:
$$
\begin{align}
x+y&=(x_{0},x_{1},\dots,x_{n-1})+(y_{0},y_{1},\dots,y_{n-1}) \\
&=(x_{0}+y_{0},x_{1}+y_{1},\dots,x_{n-1}+y_{n-1}) \\
&=(z_{0},z_{1},\dots,z_{n-1}) \\
&=\pmb{z}
\end{align}
$$
serial code:
```c
	void vector_sum(double x[], double y[], double z[], int n){
		int i;
		for(i = 0; i < n i++)
			z[i] = x[i] + y[i];
	}
```

first parallel implementation:
```c
void parallel_vector_sum(
		double local_x[], // in
		double local_y[], // in
		double local_z[], // out
		int    local_n    // in
) {
	int local_i;
	for (local_i=0; local_i<local_n; local_i++)
		local_z[local_i] = local_x[local_i] + local_y[local_i];
}

```

>[!example] using a gather to print a distributed vector
## collectives on matrices
>[!info] storage of static matrices
matrices get stored as rows in memory
![[Pasted image 20251103150205.png]]
so we could use a reduce collective to sum a matrix !

it is different for dynamically allocated matrices: 
```c 
//allocation
int** a;
a = (int**) malloc(sizeof(int*)*num_rows);
for (int i=0; i<num_rows; i++) {
	a[i] = (int*) malloc(sizeof(int)*num_cols)
}
```

sum up the matrix, this is the correct way:
```c
for(int i = 0; i < num_rows; i++){
	MPI_Reduce(a[i], recvbuf[i], num_cols, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
}
```

we can also *linearize matrices* by allocating them as continous row ! we then have to access them in a different way, but collectives become much easier
```c
int* a;
a = (int*) malloc(sizeof(int)*num_rows*num_cols);
// ...
// ...
// a[i][j]
a[i * num_cols + j] = ...

// we can then call
MPI_Reduce(a, recvbuf, num_rows*num_cols, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
```

## example: matrix-vector multiplication
>[!info] rember ?
![[Pasted image 20251103150821.png]]
>
![[Pasted image 20251103150907.png]]

to parallelize matrix multiplication:
1. *broadcast* the vector `x`from rank 0 to all the other processes
2. *scatter* the rows of the matrix `A` from rank 0 to the other processes
3. each process computes a subset of the elements of the resulting vector `y`
4. *gather* the final vector `y` to rank 0

let’s be annoying. lets use the output of the multiplication as the new array `y` and multiply `A` by `y` in a loop. to make this happen, al we need to do is add another step: 
5. *broadcast* the vector `y` from rank 0 to the other processes

we would need to do a *gather + broadcast* of one vector (so collect it first, then send it to all the processes). luckily, there exists a dedicated collective function that does this: [[02 - collective communication#`MPI_Allgather`|MPI_Allgather]]

