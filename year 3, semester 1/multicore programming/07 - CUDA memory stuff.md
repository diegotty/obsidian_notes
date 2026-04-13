---
related to: "[[06 - caches and multicore memory architectures]]"
created: 2026-02-26, 08:05
updated: 2026-03-10T21:16
completed: false
---
`cudaMemcpy()` uses *DMA* (direct memory access) hardware [[dispositivi IO, buffering#DMA|(os1)]] for better efficiency (as it frees the CPU for other tasks)
- the DMA is specialized to transfer a number of bytes requested by OS between physical memory address space regions
>[!info] illustration
![[Pasted image 20260226080907.png]]

## virtual memory management
modern systems use *virtual memory management*, mapping many virtual memory spaces into a single RAM, and translating virtual addresses (pointer values) into physical addresses
as RAM is limited, computers cannot keep all variables and data structures in it. memory is divided into *pages*, fixed-size chunks of memory that get moved in and out of RAM as needed.
when a program requests a piece of data, the system translates the virtual addresses, and during this step it checks whether the requested page is currently sitting in RAM or it was *paged out* on the hard drive

the DMA uses physical addresses, and page presence is checked for the entire source and destination regions at the beginning of each DMA transfer (at the time of address translation)
- however no address translation is needed for the rest of the DMA transfer, achieving high efficiency
>[!warning] the OS could accidentally page-out the data that is being read or written by a DMA and page-in another virtual page into the same physical location !

### pinned memory
to solve this, *pinned memory* (*page locked memory* / *locked pages*) is implemented. they are virtual memory pages that are specially marked so that they cannot be paged out
- they are allocated with a special API function call
>[!info] CPU memory that serves as the source/destination of a DMA transfer must be allocated as pinned memory !
- if it is not allocated as pinned memory, it needs to be copied first to a pinned memory, adding extra overhead
pinned memory can be allocated with `malloc()` followed by `mlock()`, and deallocated with `mulock()` followed by `free()` or `cudaMallocHost()` (deallocatd with `cudaFreeHost()`)
>[!info] performance gain
the performance gained obtained via pinned memory depends on the size of the data to be transferred, and it can range from 10% to a *massive* 2.5x

## bank conflicts in shared memory
shared memory is split into banks:
>[!info] shared memory banks
![[Pasted image 20260310201644.png]]
>- devices of compute capabilities 2.0 and above have 32 banks, while earlier devices have 16.
>- each bank can serve one access per cycle 
>	- if threads access different banks in shared memory, access is instantaneous
>	- however if threads access different data but on the same bank, the access is serialized

>[!example] bank conflicts examples
![[Pasted image 20260310202446.png]]

thus threads in a warp/half-warp should avoid accessing at the same time locations in the same shared memory bank !
- it is worth keeping in mind that if all threads in a warp access the same memory location, the hardware does a broadcast read (*no conflicts*), and from CC 2.0 if subsets of threads in a warp access the same memory location, the hardware does a multicast read (*no conflicts*)
## global memory coalescing
in practice, when a thread accesses a memory location, a *burst* of consecutive locations is actually read (similar to when loading a block of consecutive memory locations into a cache line)
when *all threads* in a warp execute a load instruction, the hardware detects if they access consecutive global memory locations: if that is the case, the hardware *coalesces* all these into a single access
>[!example] coalesced access example
> for a given load instruction of a warp, `t0` accesses global memory location $N$, `t1` location $N+1$, `t2` location $N+2$, and so on.
in this case, all these accesses will be coalesced (combined into a single request for consecutive locations when accessing the DRAMs)
![[Pasted image 20260310203812.png]]

CUDA devices might impose requiremed on the alignment of N !
## global memory accesses
there are two types of loads:
- *cached loads*, used by default for devices that have L1 caches
	- check L1, if not present check L2, if not present check global memory
	- load granularity: 128-byte line
- *non-cached loads*, if the device does not have the L1 cache (or if it does and you compile with `-Xptxas -dlcm=cg`)
	- check L2, if not present then check global memory
	- load granularity: 32-byte line
## disabling L1 cache
>[!example] examples
![[Pasted image 20260310204259.png]]
![[Pasted image 20260310204320.png]]
![[Pasted image 20260310204400.png]]
![[Pasted image 20260310204424.png]]
![[Pasted image 20260310204517.png]]

>[!warning] if you have non-coalesced or non-aligned memory accesses, it might be worth considering disabling the L1 cache !!!
## importance of data structure organization for coalesced accesses
>[!info] array-of-struct vs struct-of-array
![[Pasted image 20260310204911.png]]
as we can see below, array-of-struct wastes space in the cache due to unnedeed `y` values.
with struct-of-array, we only bring in bursts of data we need (containing `x`values), thus enabling coalesced accesses (and might require less space, as array-of-struct might require padding)
![[Pasted image 20260310204958.png]]
## reduce on GPU
>[!info] dumb reduce
![[Pasted image 20260310205312.png]]
>```c
>// assume we have already loaded array into __shared__ float partialSum[]
>
>unsigned int = threadIdx.x;
>for (unsigned int stride = 1; stride < blockDim.x; stride *= 2){
>	__syncthreads();
>	if (t % (2*stride) == 0) partialSum[t] += partialSum[t + stride];
>}
>```

however, some threads perform addition while others do not: threads that do not perform addition will do nothing
- no more than half of the threads will be executing at any time, and all odd index threads are disabled right from the beginning !
- after the 5th iteration, `stride > 32`, and entire warps in each block will be disabled, leading to poor resource utilization but no divergence
>[!info] smart reduce
![[Pasted image 20260310205528.png]]
>```c
>__shared__ float partialSum[SIZE];
>partialSum[threadIdx.x] = X[blockIdx.x * blockDim.x + threadIdx.x];
>
>unsigned int t = threadIdx.x;
>for (unsigned int stride = blockDim.x / 2; stride >= 1; stride = stride >> 1)
>{
>    __syncthreads();
>    if (t < stride)
>        partialSum[t] += partialSum[t + stride];
>}
>```
//TODO spiegare meglio

if $N$ > `block_size` , how do we reduce a vector larger than the number of threads per block ?
- shared memory is only accessible to threads within the same block
>[!example]
we can use a kernel `reduce<<<n_block, n_threads>>>(v, partial)`, launching many blocks (each takes a segment of the original array `v` and reduce it to a single value) and ending up with an intermediate array called `partial` in global memory (containing `n_block` elements, one sum for each block)
we then use `reduce<<<1, n_block>>>(partial, result)` launching a single block that reduces `partial`, calculating the single sum value

## moving data between GPUs
to move data between inter-node GPUs, there are 2 different solutions, based on whether MPI is GPU-aware or not:
- *MPI is not GPU-aware*: data must be transferred from device to host memory before making the desired MPI call (and viceversa for the receiving side)
- *MPI is GPU-aware*: MPI can access device buffers directly, hence pointers to device memory can be used in MPI calls
(on the cluster MPI is not GPU-aware)