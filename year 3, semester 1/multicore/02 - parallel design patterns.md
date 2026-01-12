---
related to: "[[00 - introduction]]"
created: 2025-03-02T17:41
updated: 2026-01-12T06:06
completed: false
---
# parallel program structure patterns
we can distinguish the *parallel program structure patterns* into two major categories:
## GPLS 
or **globally parallel, locally sequential**, it means that the application is able to *perform multiple tasks concurrently*, with each task running sequentially.
patterns that fall into this category are:
###  SPMD
SPMD keeps all the application logic in a single program, and its structure typically involves:
- program inizialization
- obtaining a unique identifier: numbered from 0, IDs enumerate the threads/processes used. some systems use *vector identifiers*
- running the program: the execution path is diversified based on the ID
- shutting down the program: clean-up, saving results, etc.
it fails when:
- memory requirements are too high for all nodes
- heterogeneous platforms are involved
### MPMD
MPMD’s structure is identical to SPMD, but deployment involves different programs
>[!info] both SPMD and MPMP are supported by MPI
### master-worker
the processes are divided into two kinds of components:
- *masters*:  one or more, is responsible for:
	- handing out pieces of work to workers
	- collecting the results of the work done by the workers
	- performing I/O duties on behalf of the workers (i.e. sending them the data they are supposed to process, accessing a file, ..)
	- interacting with the user
	clearly, the master can be a bottleneck ! however, we can use a hierarchy of masters
- *workers*: do the work given by the masters. the same function is applied to different data items
### map-reduce
a variation of the master-worker pattern, made popular by google’s search engine implementation
the master coordinates the whole operation.
workers run two typers of tasks:
- *map*: apply a function on data, resulting in a set of partial results
- *reduce*: collect the partial results and derive the complete one ([[01 - introduction and message sending#`MPI_Reduce`]])
maps and reduce workers (so they are 2 different types of workers) can vary in number. the same function is applied to different parts of a single data item
## GSLP
 or **globally sequential, locally parallel**, it means that the application executes as a sequential program, with individual parts of it running in parallel when requested.
 patterns that fall into this category are:
### fork / join
there is a single parent thread of execution, and dynamic creation of *children tasks* at run-time. the tasks may run via threads that spawn, or via use of a static pool of threads.
- children tasks have to finish for parent thread to continue !!! (of course, as its globally sequential)
>[!info] implemented by OpenMP and Pthread

>[!example] ex

```c
mergesort(A, lo, hi):
	if lo < hi: // length of A >=1
		mid = [lo + (hi - lo)/2]
		fork mergesort(A, lo, mid) // child task
		mergesort(A, mid, hi) // done by the main task
		join
		merge(A, lo, mid, hi)
```

### loop parallelism
this technique is employed for *migration of sequential/legacy software to multicore*. it focuses on breaking up loops by manipulating the loop control variable
- a loop has to be in a particular form to support this
the flexibility with this approach is limited, but so is the development effort
>[!info] supported by OpenMP
 
 >[!info] img
 ![[Pasted image 20251022113348.png]]

## trapezoid example
>[!info] idea
>let’s approximate the definite integral of a function by calculating the trapezoids inside it !
>
given two points, $a$ and $b$, we choose an $h$ value that will be the same for each of the $n$ trapezoids
>![[Pasted image 20251028104743.png]]
area of a trapezoid : $\frac{h}{2}[l_{1}+l_{2}]$ ( with $l_{1},l_{2}$ as the two parallel sides, and $h$ the height of the trapezoid)
>
so we divide the the distance from $a$ to $b$ in $n+1$ points:
>$$
>x_{0} = a, x_{1} = a + h, x_{2} = a + 2h, \dots, x_{n-1} = a + (n-1)h, x_{n} = b
>$$
>
to find the length of $l_{1},l_{2}$ for each trapezoid, we calculate their image for $f(x)$. so the area of the trapezoid with 4 vertices $x_{i}, x_{i+1}, f(x_{i}), f(x_{i+1})$ is: $\frac{h}{2}[f(x_{i})+f(x_{i+1})]$
>
and the sum of trapezoid areas is:
>$$
>\sum^{n-1}_{{i=0}} \frac{h}{2}[f(x_{i}) + f(x_{i+1})] = 
>h\left[ \frac{f(x_{0})}{2} + f(x_{1}) +f(x_{2})+\dots+\frac{f(x_{n})}{2}) \right]
>$$
(because each term except the first and the last one appear twice)

the pseudocode to calculate the area of $n$ trapezoids from $a$ to $b$ is:
```c
h = (b-a)/n;
approx = (f(a) + f(b)) /2.0; // first and last term
for (i = 1; i <= n-1; i++) {
	x_i = a + i*h;
	approx += f(x_i);
}
approx = h*approx;
```

>[!info] parallelizing
>we parallelize this program by:
>1. partitioning the problem solution into tasks
>2. indentifying common channels between tasks
>3. aggregating tasks into composite tasks
>4. mapping composite tasks to cores
>
>![[Pasted image 20251028105022.png]]
(master-worker pattern)

parallel pseudo-code:
```c
get a,b,n;
h = (b-a)/n;
local_n = n/comm_sz; // num of trapezoids to calculate
local_a = a + my_rank*local_n*h; // starting point
local_b = a + local_n*h; // ending point
local_integral = trap(local_a, local_b, local_n, h);
if(my_rank != 0){
	send local_integral to process 0;
}else{
	total_integral = local_integral; // (f(a) + f(b))/2
	for (proc = 1; proc < comm_sz; proc++){
		receive local_integral from proc;
		total_integral += local_integral;
	}
}
if (my_rank == 0):
	print total_integral;
```
 
### input
most MPI programs *only allow process 0 in `MPI_COMM_WORLD` to access to stdin*.
so process 0 must read the data (with `scanf()` and send it to the other processes !

we do this by calling a function (for every process). in this case:
```c
void get_input( int my_rank, int comm_sz, double* a, double* b, int* n){
	int dest;
	
	if (my_rank == 0){
		for(dest = 1; dest < comm_sz; dest++){
			MPI_Send(a, 1, MPI_DOUBLE, dest, 0, MPI_COMM_WORLD);
			MPI_Send(b, 1, MPI_DOUBLE, dest, 0, MPI_COMM_WORLD);
			MPI_Send(n, 1, MPI_INT, dest, 0, MPI_COMM_WORLD);
		}
	}else{
		MPI_Recv(a, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		MPI_Recv(b, 1, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		MPI_Recv(n, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	}
	
}

```

>[!example] problems
as we saw previously, when doing the global sum, $p-1$ processes send their data to one process, which then computes all the sums. this is *unbalanced*, as:
>- time for process 0: $(p-1)\cdot(T_{sum}+T_{recv})$
>- time for all the other processes: $T_{send}$
>
we can alter this by using a different tree
![[Pasted image 20251028112725.png]]
this way, the time for process 0 is $\log_{2}(p) \cdot(T_{sum}+ T_{recv})$
>
>the same issue is encountered with sending the values, as process 0 has to send them to $p-1$ processes. we can use another tree to pass the values !
![[Pasted image 20251030112145.png]]

however, the optimal way to compute a global sum *depends on the number of processes, the size of the data, and the system*. having a native way to express the global sum would simplify programming and improve performance !
this is implemented with functions like [[01 - introduction and message sending#`MPI_Reduce`|MPI_Reduce]] !
for this example, the call would be:
```c
MPI_Reduce(&local_int, &total_int, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
```