---
related to: "[[02 - parallel design patterns]]"
created: 2025-11-25, 17:14
updated: 2025-12-14T11:51
completed: false
---
# CUDA
## CPU vs GPU
*CPU*s are *latency oriented* (how much time it takes to complete a single task) they aim for high clock frequency, and feature:
- large caches, to convert long latency memory to short latency cache accesses
- sophisticated control mechanisms to reduce latency (like branch prediction, out-of-order execution, …)
- powerful ALUs (each ALU is considered a core)
>[!figure] CPU
![[Pasted image 20251126105239.png|400]]
>the percent of the CPU designated to make calculations is small

*GPU*s are *throughput oriented* (amount of work done for unit of time), so they feature:
- moderate clock frequency
- small caches
- energy efficient ALUs, that are long-latency but heavily pipelined for high throughput
- simple control (no branch prediction, just in-order execution)
- high bandwith (the rate at which data can be transferred between CUDA cores and the GPUs dedicated local memory (VRAM) is very high)
>[!figure] img
![[Pasted image 20251126110026.png]]
the are many more ALUs, however they are simpler and grouped: each group is controlled by a single CU (so each ALU is not independent)

## architecture of CUDA-capable GPUs
>[!info] img
![[Pasted image 20251126110207.png]]

- *streaming processors/cuda cores* (*SP*): basically a single ALU (but optimized for parallel code execution)
- *streaming multiprocessors* (*SM*): set of SPs ( == CPU). su SM ho una CU per warp e i warp runnano in parallelo
- *building blocks*: two or more SMs (those SMs share the same chache and texture memory)

>[!info] CPU vs GPU
CPUs are optimal for sequential parts, where latency matters
>- they can be 10+X times faster than GPUs for sequential code
>GPUs are optimal for parallel parts, where throughput matters
>- they can be 10+X times faster than GPUs for parallel code

## CPU-GPU architectures
>[!info] CPU-GPU architecture
![[Pasted image 20251126112715.png]]
 
 - architecture (*a*): older architecture where GPU, CPU and RAM are all connected to the *northbridge*
	- the GPU is connected to the northbridge via a high-speed link like PCIe (express)
	- the data transfer between CPU and GPU (or RAM and VRAM) must pass through the northbridge, ading latency and extra steps
 - architecture (*b*): a common architectured used today, the *memory controller* (that handles RAM communication) is removed from the northbridge and placed on the CPU itself 
 - architecture (*c*): architecture of the modern integrated systems, CPU an GPU cores are combined onto a single chip package, often called an *APU*/Soc (system on a chip)
	- the CPU and GPU are physically integrated, and share the same system RAM. this eliminates the need to copy data between separate VRAM and RAM
	- the communication between CPU and GPU is extremely fast

>[!warning] GPU programming caveats
>- as shown above, usually GPU and host (CPU) memories are disjoint, requiring explicit data transfer between the two
>- GPU devices might not adhere to the same *floating-point representation* and accuracy system standards as typical CPUs
### software development platforms
the main GPU software delopment platforms are:
- *CUDA*: provides 2 sets of APIs (high-level and low-level). *only for NVIDIA hardare* (however there are tools to run CUDA code on AMD GPUs)
- *HIP*: AMD’s equivalend of CUDA. basically the same APIs, and the are tools provided to convert CUDA code to HIP
- *OpenCL*  (*open computing language*): open standard for writing programs that can execute across a variety of heterogeneous platforms that include GPUs, CPUs, DSPs or other processors. its supported by both NVIDIA and AMD, and is the primary development platform of the latter
- *OpenACC*: open standard for an API that allows the use of compiler directives (like openMP !) to automatically map computations to GPUs or multicore chips, according to the programmer
there are many more …
## warps
threads are executed in groups called *warps* that are the size of 32 threads (in current GPUs)
- the size of a warp is stored in the `warpSize` variable
- threads in a block are split into warps according to their intra-block ID: the first 32 threads of a block belong to the same warp, the next 32 threads to a different warp, etc …)
all threads in a warp are executed according to the SIMD model, so consequently all the threads in a warp will always have the same execution timing.
*several warp schedulers* can be present on each SM, as multiple warps can run at the same time, each following a different execution path
- if for example, a warp takes only a fraction of the SPs of a SM
>[!info] img
![[Pasted image 20251126182254.png]]
## warp divergence
because all threads in a warp are executed according to the SIMD model, at any instant in time, for all the threads in the warp, one istruction is fetched and executed
if a conditional operation leads those threads to different paths, all the divergent paths are evaluated *sequentially* until the paths mege again. this way, threads that do not follow the path currently being executed *are stalled*
>[!info] warp divergence
![[Pasted image 20251126182339.png]]

## context switching
usually, a SM has more *resident blocks/warps* than what it is able to concurrently run, and each SM can switch seamlessly between warps.
CUDA cores (and their registers) can maintain each thread’s private execution context: this way, CUDA cores’s context switch is basically free.
when an instruction to be executed by a warp needs to wait for the result of a previously initiated, long-latency operation, the warp is *not selected* for execution: instead, another resident warp that is not waiting for results will be selected for execution.
- this makes having more *resident warps* ideal, as the hardware is more likely to find a warp to execute at any point in time, thus making full use of the execution hardware in spite of long-latency operations
this mechanism of filling the latency time of operations with work from other threads is called *latency tolerance* or *latency hiding*

>[!info] biggest costs in GPGPUs
instead of the context switch, the biggest cost in GPU parallel computing is the transferring of data between the GPU and the CPU !

>[!example] block size esample 1
> lets suppose a CUDA device allows up to 8 blocks and 1024 threads per SM, and 512 threads per block.
should we use 8x8, 16x16, 32x32 blocks ?
>- 8x8 blocks: 64 threads per block would make it necessary to have 16 blocks to fill a SM. however, we can have at most 8 blocks per SM, ending up with 512 threads per SM. not fully utilizing the resources !!!!
>- 16x16 blocks: 256 threads per block would make it necessary to have 4 blocks to fill a SM. this would be good !!!
>- 32x32 blocks: we would have 1024 threads per block, which is higher than the 512 threads per block we can have

>[!example] block size example 2
lets suppose a CUDA device allows up to 8 blocks and 1536 threads per SM, and 1024 threads per block.
>- 8x8 blocks: 64 threads per block would make it necessary to have 24 blocks, which is more than we can have in a SM. thus we are not fully utilizing the resources
>- 16x16 blocks: 256 threads per block would make it necessary to have 6 blocks per SM, achieving full capacity
>- 32x32 blocks: 1024 threads per block would make it possible for only one block to fit in a SM, leaving almost 1/3 of the threads of each SM at rest

>[!example] block size example 3
suppose our structure looks like this:
a grid of 4x5x3 blocks, each made of 100 threads.
>- each block is divided into warps, and while the first three warps would have 32 threads, the last one would have 4. if we assume that we can only schedule a warp at a time (because we have 32 SPs per SM), then the last warp would only use 4 of the 32 available cores
>- we would have 60 blocks, to be distributed over 16 SMs. 
>// umm didnt get it

## device properties
>[!example] listing all the GPUs in a system
>```c
>int deviceCount = 0;
>cudaGetDeviceCount(&deviceCount);
>
>if(deviceCount == 0)
>    printf("No CUDA compatible GPU exists.\n");
>else
>{
>    cudaDeviceProp pr;
>    for(int i=0; i<deviceCount; i++)
>    {
>        cudaGetDeviceProperties(&pr, i);
>        printf("Dev #%i is %s\n", i, pr.name);
>    }
>}
>```

>[!info] device properties struct definition
>```c
>struct cudaDeviceProp {
>    char name[256];             // A string identifying the device
>    int major;                  // Compute capability major number
>    int minor;                  // Compute capability minor number
>    int maxGridSize [3];
>    int maxThreadsDim [3];
>    int maxThreadsPerBlock;
>    int maxThreadsPerMultiProcessor;
>    int multiProcessorCount;
>    int regsPerBlock;           // Number of registers per block
>    size_t sharedMemPerBlock;
>    size_t totalGlobalMem;
>    int warpSize;
>    // . . .
>};
>```
## memory types
memory is divided into *on-chip memory* (integrated on the GPU die) and *off-chip memory* (located outside the main GPU die, still mounted on the circuit board : the VRAM)
>[!info] img
![[Pasted image 20251201223801.png]]
the GPU die contains the SMs, the shared memory and the L2 cache

there are multiple types of memories:
- *registers*: they hold local variables, and are unique to each SP.
- *shared memory*: fast on-chip memory that holds frequenty used data. it can also be used *to exchange data between SPs of the same SM*.
- *L1/L2 cache*: these caches are transparent to the programmer. (and act just as you would expect [[year 1, semester 2/ae/cache/intro| (already done ….)]])
- *global memory*:  main part of the off-chip memory. high capacity but relatively slow, it is the *only part accessible* through CUDA functions
- *texture and surface memory*: content managed by special hardware that permits fast implementation of some filtering/interpolation operator
- *constant memory*: part of the memory that can only store constants. it is cached, *allows for broadcasting of a single value to all threads in a warp*
the following table show CUDA variables’s scope and lifetime

| variable declaration                    | memory   | scope  | lifetime    |
| --------------------------------------- | -------- | ------ | ----------- |
| automatic variables other than arrays   | register | thread | kernel      |
| automatic array variables               | global   | thread | kernel      |
| `__device__ __shared__` int SharedVar;  | shared   | block  | kernel      |
| `__device__` int GlobalVar;             | global   | grid   | application |
| `__device__ __constant__` int ConstVar; | constant | grid   | application |
### registers
they are used to store local variables to a thread
- *registers on a core are split among the resident threads !*
- compute capability determines the maximum number of registers that can be used per thread. if this number is exceeded, local variables are allocated in the global (off-chip) memory (which is very slow)
	- spilled variables could also be cached in the L1 on-chip cache
	- the compiler will decide which variables will be allocated in the registers and which will spill over to global memory
>[!info] how the number of maximum registers influences the resident threads
>nvidia defines as *occupancy* the ratio of resident warps over the maximum possible resident warps
>$$\text{occupancy} = \frac{\text{resident\_warps}}{\text{maximum\_warps}}$$
>>[!example] example
>we assume that the target GPU has $32.000$ registers per SM, and can have up to $1.536$ resident threads per SM
>>- a kernel uses 48 registers
>>- a block is 256 threads
>>	- each block requires $256 \cdot48=12.288$ registers
>>- thus, each SM could have 2 resident blocks (as $12.288\cdot 2< 32.000 < 12.288\cdot 3$), and $512$ resident threads
>>512 is much below the maximum limit of the $1.536$ threads !
>>- this undermines the possiblity to hide latency
>
an occupancy close to 1 is desirable, as the closer it is the higher the opportunities to swap between threads and hide latencies
>- the occupancy of a given kernel can be analyzed through a profiler
>to increase occupancy, we can:
>- reduce the number of registers required by the kernel
>- use a GPU with higher registers per thread limit
>(duh)

### constant memory
a m
!= ROM
### shared memory
it is a *on-chip memory* that is shared among threads. it can be seen as a user-managed L1 memory (also called scratchpad)
### 1D stencil example
risultato viene scritto su un altro array
original array è ready only
viene usato un “padding” per elementi a sx e dx

halo sx e dx (2 * radius)
usiamo 2 array x fare in parallelo

`gindex`: gobal index for the thread inside the array (halos included)
`lindex`: local index for the array relative to the block (we sum `RADIUS` which is the halo, which we imported on `temp`


carico tutti i dati in shared memory

i primi elementi con `lindex` iniziali si compiano gli halo dx e sx
sarebbbe possibile mandare in esecuzione un warp 
### image to grayscale example
we can see an j
`greyOffset`: index for the element i need to work on, on the linearized array
`CHANNLES` = 3 in quanto ogni pixel ha 3 colori
### image blur example
## performance estimation
andrebbe specificare con quali elementi faccio operazioni flop