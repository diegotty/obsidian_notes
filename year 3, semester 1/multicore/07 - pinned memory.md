---
related to: "[[06 - caches and multicore memory architectures]]"
created: 2026-02-26, 08:05
updated: 2026-03-10T20:34
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