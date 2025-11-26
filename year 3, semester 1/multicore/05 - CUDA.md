---
related to:
created: 2025-11-25, 17:14
updated: 2025-11-26T14:27
completed: false
---
# CUDA
## CUDA intrudction
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
the are many more ALUs, however they are simpler and grouped (not every ALU is independent), because each group is controlled by a single CU

## architecture of CUDA-capable GPUs
>[!info] img
![[Pasted image 20251126110207.png]]

- *streaming processors/cuda cores* (*SP*): basically a single ALU (but optimized for parallel code execution)
- *streaming multiprocessors* (*SM*): set of SMs
- *building blocks*: two or more SMs (those SMs share the same chache and texture memory)

>[!info] CPU vs GPU
CPUs are optimal for sequential parts, where latency matters
>- they can be 10+X times faster than GPUs for sequential code
>GPUs are optimal for parallel parts, where throughput matters
>- they can be 10+X times faster than GPUs for parallel code

## CPU-GPU architectures
>[!info] CPU-GPU architecture
![[Pasted image 20251126112715.png]]
 
 architecture (*a*): older architecture where GPU, CPU and RAM are all connected to the *northbridge*
- the GPU is connected to the northbridge via a high-speed link like PCIe (express)
- the data transfer between CPU and GPU (or RAM and VRAM) must pass through the northbridge, ading latency and extra steps
 architecture (*b*): a common architectured used today, the *memory controller* (that handles RAM communication) is removed from the northbridge and placed on the CPU itself 
 architecture (*c*): architecture of the modern integrated systems, CPU an GPU cores are combined onto a single chip package, often called an *APU*/Soc (system on a chip)
- the CPU and GPU are physically integrated, and share the same system RAM. this eliminates the need to copy data between separate VRAM and RAM
- the communication between CPU and GPU is extremely fast
>[!warning] GPU programming caveats
>- as shown above, usually GPU and host (CPU) memories are disjoint, requiring explicit data transfer between the two
>- GPU devices might not adhere to the same *floating-point representation* and accuracy system standards as typical CPUs
### software development platforms
the main GPU software delopment platforms are:
- *CUDA*: provides 2 sets of APIs (high-level and low-level). *only for NVidia hardare* (however there are tools to run CUDA code on AMD GPUs)
- *HIP*: AMD’s equivalend of CUDA. basically the same APIs, and the are tools provided to convert CUDA code to HIP
- *OpenCL*  (*open computing language*): open standard for writing programs that can execute across a variety of heterogeneous platforms that include GPUs, CPUs, DSPs or other processors. its supported by both NVidia and AMD, and is the primary development platform of the latter
- *OpenACC*: open standard for an API that allows the use of compiler directives (like openMP !) to automatically map computations to GPUs or multicore chips, according to the programmer
there are many more …
## CUDA
it turns a GPU from a graphics renderer into  a *general purpose computing* device (*GPGPU*)
before CUDA, GPUs were programmed by transforming an algorithm in a sequence of image manipulation primitives

it enables explicit GPU *memory management*

the GPU is viewed as a *compute device*, that:
- is a co-processor to the CPU
- has its own DRAM (called *global memory* in CUDA lingo)
- runs *many threads* in parallel, as thread creation/switching cost is only a few clock cycles !
can explicit 

>[!info] CUDA program structure
> - allocate GPU memory (for anything like vectors, variables, ..)
>- explicitly transfer data from host to GPU memory
>- run CUDA kernel (computations executed by the GPU)
>- copy results from GPU memory to host memory


running kernels is expensive, so its better to run it less times for more substantial computations (*kernel fusion*)
### execution model
>[!info] execution flow
![[Pasted image 20251126121419.png]]
>in the vast majority of scenarios, the host is responsible for I/O operations, passing the input and subsequently collecting the output data from the memory space of the GPU

>[!info] thread structure
![[Pasted image 20251126121341.png]]
CUDA organizes the threads in a 6-D structure (max, as lower dimentions are also possible). in particular:
>- threads can be organized in *blocks* o 1, 2, or 3 dimentions
>- those blocks are organized in *grids* of 1, 2, or 3 dimensions
## compute capability
the maximum sizes of blocks and grids are determined by the *compute capability*, which determines what each generation of GPUs is capable of
- it is repre
### thread position
each thread is *aware of its position* in the overall structure, via a set of *intrinsic variables/structures*. with this position, a thread can map its position to the subset of data that it is assigned to.
>[!warning]
- scelta molto importante

the adjust the execution model to the data we are working on

threads on the GPU can do minimal work, like just an instruction

## writing programs
paradigma usato di solito SIMD (SIMT x CUDA)

.cu == .c ma come convenzione viene eseguito su gpu

(decorator )`__global__` func: can be called by host or GPU, but will be executed by the GPU (the compiler generates assembly code for the GPU instead of for the GPU, as they have different instruction sets, and a different compiler, `nvcc`)

all kernels have `void` as the return type (if we want to send a result, we must copy it from the GPU’s memory to the host memory)

shouldnt call printf on kernels (very slow)

kernel calls are async: they give the control back to the cpu (so i must use `cudaDevicesSynchronize();` to ensure synchronization)

–arch=`capability`

## function dectorators
- `__global__` (kernel can call kernel)
- `__device`
- `__host__`
we can mix and match them and get 2 different assembly codes for both host and GPU (host + device)


domanda esame come trovare posizione thread …...


ogni cudacore può eseguire più di un tread alla volta, ma di solito un thread runna su un cudacore

blocks cant be split between different SMs


posso avere + blocks in una SM
scheduling su cudacore è praticamente gratis rispetto a CPU ! 
blocks are divided in warps (thread continigui divenano thread)

WARP (32 core) hanno la stessa CU 

## context switching
usually, a SM has more *resident blocks/warps* than what it is able to concurrently run, and each SM can switch seamlessly between warps

cores (and their registers) can maintain each thread’s private execution context


costo + grande dei programmi ora è il trasferimento dei dati dalla memoria 

*latency tolerance* bc we dont wait for the load inst