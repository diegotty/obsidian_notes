---
related to:
created: 2025-12-14, 11:49
updated: 2025-12-14T11:51
completed: false
---
# CUDA
*CUDA* (*compute unified device architecture*) is a parallel computing *platform and programming model* developed by NVIDIA.
it is a *programming model* because it provides a conceptual framework on how problem are broken down and how the components interact, without specifying the exact syntax or implementation. (na robba fumosa)
it comprehends
- a compiler (*nvcc*)
 - a runtime API: a library that manages the GPU device, handles memory allocation, and launches the kernels from the host code
 - highly optimized libraries
it turns a GPU from a graphics renderer into  a *general purpose computing* device (*GPGPU*)
before CUDA, GPUs were programmed by transforming an algorithm in a sequence of image manipulation primitives
- it enables explicit GPU *memory management* (GPU’s memory and the exchange between CPU and GPU)

the GPU is viewed as a *compute device*, that:
- is a co-processor to the CPU
- has its own DRAM (called *global memory* in CUDA lingo)
- runs *many threads* in parallel, as thread creation/switching cost is only a few clock cycles !
can explicit 

>[!info] CUDA program structure
> 1. allocate GPU memory (for anything like vectors, variables, ..)
>2. explicitly transfer data from host to GPU memory
>3. run CUDA kernel (computations executed by the GPU)
>4. copy results from GPU memory to host memory

running kernels is expensive, so its better to run them  less times for more substantial computations (*kernel fusion*)
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
- it identifies the features supported by the GPU hardware and is used by applications at runtime to determine which hardware features and/or instructions are available on the present GPU
- it is represented by a version number, and sometimes it is called *SM version*
>[!info] CC (compute capability) properties
![[Pasted image 20251126170458.png]]
we got to 9 n something

>[!example] NVidia architectures
>![[Pasted image 20251126170236.png]]

### thread position
(this stuff gets asket during the oral exam …..)
each thread is *aware of its position* in the overall structure, via a set of *intrinsic variables/structures*. with this position, a thread can map its position to the subset of data that it is assigned to.
- `blockDim` contains the size of each block, as $(B_{x}, B_{y}, B_{z})$
- `gridDim` contains the size of the grid, in blocks, as $(G_{x}, G_{y}, G_{z})$
- `threadIdx` contains the $(x,y,z)$ position of the thread within a block, with:
	- $x \in [0,B_{x}-1]$
	- $y \in [0, B_{y}-1]$
	- $z \in [0, B_{z}-1]$
- `blockIdx`contains the $(b_{x}, b_{y}, b_{z})$ position of a thread’s block within the grid, with:
	- $b_{x} \in [0,G_{x}-1]$
	- $b_{y} \in [0, G_{y}-1]$
	- $b_{z} \in [0, B_{z}-1]$

- scelta molto importante

>[!example] absolute position of a thread
![[Pasted image 20251126182910.png]]

>[!example]- absolute position of a thread, linear structure
![[Pasted image 20251126180318.png]]

>[!syntax] unique thread identifier
>```c
>int myID = ( blockIdx.z * gridDim.x * gridDim.y +
>            blockIdx.y * gridDim.x +
>            blockIdx.x ) * blockDim.x * blockDim.y * blockDim.z +
>            threadIdx.z * blockDim.x * blockDim.y +
>            threadIdx.y * blockDim.x +
>            threadIdx.x;
>```
the adjust the execution model to the data we are working on

threads on the GPU can do minimal work, like just an instruction

## writing programs
the parallel programming paradigm used by CUDA is usually [[02 - parallel design patterns#SPMD|SPMD]] (or rather *SIMT* (*single instruction, multiple threads*))
we achieve parallel programming by writing *kernels* (functions) that are going to be executed by all the threads
- all kernels have `void` as the return type, as if we want to send a result, we must do so but moving the data from the GPU’s memory to the CPU
- kernel calls are asynchronous: they give the control back to the host (so `cudaDevicesSynchronize();` is necessary to ensure synchronization)

 it is necessary to specify how threads are arranged in the blocks and how the blocks are arranged in the grid
>[!syntax] specifying the thread structure
>```c
// kinda self explanatory
dim3 block(3, 2);
dim3 grid(4, 3, 2);
>foo<<grid, block>>();
>
>foo<<grid, 256>>;
>```
>- the dimentions allowed must be supported by the computing capabilities
>- dim3 is a vector of int
>- every non-specified component is set to 1

>[!example]
>```c
>// hello.cu
>#include <stdio.h>
>#include <cuda.h>
>
//kernel
>__global__ void hello() {
>	// printf is supported by CC 2.0 
>	printf("Hello world!\n");
>}
>
>int main() {
>	hello<<<1,10>>>();
>	// blocks until the CUDA kernel terminates
>	cudaDeviceSyncronize();
>	return 1;
>}
>```

>[!syntax] compiling and running
>```bash
>nvcc --arch=sm_20 hello.cu -o hello
>./hello //execute
>```

CUDA files are of `.cu` extension, which is the same as `.c`, however at serves as a convention as `.cu` files are expected to be run on GPUs
## function dectorators
- `__global__` : (kernel can call kernel)
- `__global__` : a function that can be called by host or GPU, but will be executed by the GPU 
	- the compiler generates assembly code for the GPU instead of for the GPU, as they have different instruction sets, and a different compiler (`nvcc`))
- `__device__`: a function that runs on the GPU and can be only called from within a kernel (so basically, by a GPU)
- `__host__`: a function that can only run on the host.
	- this decorator is typically omitted, unless in combination with `__device__` to indicate that the function can run on both the host and the device. such a scenario implies the generation of two compiled codes for the function !

## thread scheduling
each thread runs on CUDA core, and *sets of cores on the same SM share the same CU*, so they must *synchronously* execute the same instruction
- different sets of SMs can run different kernels
each block runs on a single SM (i can’t have a block spanning over multiple SMs, but i can have more blocks running on the same SM), but *not all the threads in a block run concurrently*
once a block is fully executed (all threads are done ?), the SM will run the next one 
## vector addition example
>[!example] 
![[Pasted image 20251201221457.png]]
>
>```c
>//h_ specifies it is memory on the host 
>void vecAdd(float* h_A, float* h_B, float* h_C, int n)
>{
>    int size = n * sizeof(float);
>	// d_ specifies it is memory on the device
>    float *d_A, *d_B, *d_C;
>
>    cudaMalloc((void**) &d_A, size);
>    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
>
>    cudaMalloc((void**) &d_B, size);
>    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);
>
>    cudaMalloc((void**) &d_C, size);
>	
>	vecAddKernel<<ceil(n/256.0), 256>>(d_A, d_B, d_C, n);
>
>    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost); 
>
>    cudaFree(d_A);
>    cudaFree(d_B);
>    cudaFree(d_C);
>}
>```
>- in this case, we might be running ceil(n/256) blocks. if n is not a multiple of 256, could run more threads than number of elements in the vector.
>	- each thread must then check if it needs to process some element or not
>
>```c
>__global__
>void vecAddKernel(float* A, float* B, float* C, int n){
>	int i = blockDim.x * blockIdx.x + threadIdx.x;
>	// check if thread is supposed to do something
>	if (i < n) C[i] = A[i] + B[i];
>}
>```
>![[Pasted image 20251201223014.png]]

>[!info] good practice (error checking)
we should check the `cudaError_t` return variable to handle any errors
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
>int deviceCount = 0;
>
>cudaGetDeviceCount(&deviceCount);
>```

## memory 
>[!syntax] syntax
the following calls are made from the host:
>```c
>// allocate memory on the device
>cudaError_t cudaMalloc ( 
>    void** devPtr,          
>    size_t size
>);
>```
>- `devPtr`: pointer address of the hosts’s memory, where the address of the *allocated device memory* will be stored
>- `size`: size in bytes of the requested memory block
>
>```c
>// frees memory on the device
>cudaError_t cudaFree ( 
>    void* devPtr
>);
>```
>- `devPtr`: host pointer address modified by `cudaMalloc()`
>
>```c
>// copies data between host and device
>cudaError_t cudaMemcpy ( 
>    void* dst,
>    const void* src,
>    size_t count,
>    cudaMemcpyKind kind
>);
>```
>- `dst`: destination block address
>- `src`: source block address
>- `count`: size in bytes
> - `kind`: direction of the copy

- `cudaError_t` is an enumerated type: if it returns anything other than `0` (`cudaSuccess`), an error has occurred
- `cudaMemcpyKind` is also an enumerated type, allowing the following values:
	- `cudaMemcpyHostToHost`(`0`)
	- `cudaMemcpyHostToDevice`(`1`)
	- `cudaMemcpyDeviceToHost`(`2`)
	- `cudaMemcpyDeviceToDevice`(`3`): this value, used in multi-GPU configurations, works only if the two devices are on the same server system
	- `cudaMemoryDefault` (`4`): used when unified virtual address space is available