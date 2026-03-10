---
related to: "[[06 - caches and multicore memory architectures]]"
created: 2026-02-26, 08:05
updated: 2026-03-10T19:48
completed: false
---
`cudaMemcpy()` uses *DMA* (direct memory access) hardware [[dispositivi IO, buffering#DMA|(os1)]] for better efficiency (as it frees the CPU for other tasks)
- the DMA is specialized to transfer a number of bytes requested by OS between physical memory address space regions
>[!info] illustration
![[Pasted image 20260226080907.png]]

## virtual memory management
as RAM is limited, computers cannot keep all variables and data structures in it. memory is divided into *pages*, fixed-size chunks of memory that get moved in and out of RAM as needed.
when a program requests a piece of data, the system translates the virtual addresses. 