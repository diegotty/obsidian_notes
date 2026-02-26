---
related to:
created: 2025-03-02T17:41
updated: 2026-02-26T18:07
completed: false
---
*--socket-core-thread structure:*
each machine has $x$ sockets, and each socket has $k$ cores, and each core can handle $j$ threads. thus the number of threads usable in a machine is $x \cdot k \cdot j$

we run our program on the cluster with 4 nodes (4 physical servers)

each node has *2 sockets*, and each CPU (1 per socket) is split in *4 NUMA nodes*, and also each socket has *16 cores* (so 32 cores for each node)
- also *2 threads x core*
```
NUMA:                     
  NUMA node(s):           8
  NUMA node0 CPU(s):      0,8,16,24,32,40,48,56
  NUMA node1 CPU(s):      2,10,18,26,34,42,50,58
  NUMA node2 CPU(s):      4,12,20,28,36,44,52,60
  NUMA node3 CPU(s):      6,14,22,30,38,46,54,62
  NUMA node4 CPU(s):      1,9,17,25,33,41,49,57
  NUMA node5 CPU(s):      3,11,19,27,35,43,51,59
  NUMA node6 CPU(s):      5,13,21,29,37,45,53,61
  NUMA node7 CPU(s):      7,15,23,31,39,47,55,63
```
in this report, CPU(s) means thread ! not cores

```
--nodes = 4 //4 physical servers
--ntasks-per-node=8 //1 MPI rank for each of the NUMA nodes
--cpus-per-task=8 //8 logical CPUS per rank (4 cores + MST) i'll run 4
```


*MPI: bind-to & map-by*
- *map-by:* distributes processes between hardware
- *bind-to*: locks MPI processes to a specific physical part of the hardware

*omp: OMP_PLACES & OMP_PROC_BIND*
- *OMP_PLACES*: where the threads can run (at which level: `threads, cores, sockets`)
- *OMP_PROC_BIND* (affinity policy):  how threads are distributed across the places ()

*CUDA*
*Quadro RTX 6000, 7.5, 570.124.06* (gpu, compute-cap, driver-version)
each node has 2 gpus, we run with 4 nodes

*optimal block sizes are typically multiples of 32 to ensure efficient warp scheduling !*
*total threads must exceed the number of multiprocessors to hide latency*

max threads per block: 1024
max warps per SM: 32