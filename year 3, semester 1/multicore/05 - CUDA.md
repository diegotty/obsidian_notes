---
related to:
created: 2025-11-25, 17:14
updated: 2025-11-25T18:41
completed: false
---
# CUDA
## CPU vs GPU

*CPU*s are *latency oriented* (high clock frequency)
*GPU*s are *throughput oriented* (). to optimize so, it features:
WARP (32 core) hanno la stessa CU 
- i core della GPU sono + semplici perchè hanno meno CU
- bandwith + alta (x la sua ram)

SMs on the same building block share chache and texture memory


northbridge: pci express
in architectures a and b we need to take account of the fact that to do calculations on the GPU we need to move the data from the Ram to the GPU and back

### software development platforms
the main GPU software delopment platforms are:
- *CUDA*
- *HIP*
- *OpenCL*
- *OpenACC*:
## CUDA
can explicit 

>[!info] CUDA program structure
> - allocate GPU memory (for anything like vectors, variables, ..)
>- explicitly transfer data from host (CPU) to GPU memory
>- run CUDA kernel (computations executed by the GPU)
>- copy results from GPU memory to host memory


running kernels is expensive, so its better to run it less times for more substantial computations (*kernel fusion*)
### execution model
threads can be organized in blocks o 1, 2, or 3 dimentions
those blocks are organized in grids of 1, 2, or 3 dimension
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