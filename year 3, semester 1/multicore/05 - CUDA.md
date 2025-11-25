---
related to:
created: 2025-11-25, 17:14
updated: 2025-11-25T18:12
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

(decorator )`__global__` func: should be executed by the GPU (the compiler generates assembly code for the GPU instead of for the GPU, as they have different architectures (assembly architectures ?))

kernel calls are async: they give the control back to the cpu (so i must use `cudaDevicesSynchronize();` to ensure synchronization)