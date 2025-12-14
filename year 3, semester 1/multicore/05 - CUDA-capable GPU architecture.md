---
related to: "[[02 - parallel design patterns]]"
created: 2025-11-25, 17:14
updated: 2025-12-14T13:22
completed: false
---
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
- *texture and surface memory*: content managed by special hardware that permits fast implementation of some filtering/interpolation operators
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
constant memory is different from the *ROM*: it is just a off-chip writeable memory that can hold values that remain constant through the execution of a kernel. it has two main advantages:
- it is cached
- it supports broadcasting of a single value to all threads in a warp
>[!example] constant memory usage
suppose we have 10 warps on a SM, and all request the same variable:
if the data is on global memory:
>- all warps will request the same segment from global memory
>- the first time, the segment will be copied in L2 cache. however, if other data passes through L2, there are good chances that the segment will be lost !=
>- therefore, there are good chances that data will be requested multiple times
>if the data is in constant memory:
>- during first warp request: data is copied in constant-cache
>- since there is less traffic in constant memory, there are good chances that all other warps will find the data already in the memory

>[!syntax] constant memory allocation and usage
>```c
>__constant type variable_name; // allocate variable_name in constant memory
>cudaMemcpyToSymbol(variable_name, &host_src, sizeof(type), cudaMemcpyHostToDevice); // function is a variant of cudaMemcpy
>```
### shared memory
it is a *on-chip memory* that is shared among threads. it can be seen as a user-managed L1 memory (also called scratchpad). however, unlike L1, you can have a guarantee that the data you need will be in the *shared memory* !
it can be used to hold frequently used data, that would otherwise require a global memory access, or as a way for cores on the same SM to share data
>[!syntax] shared memory allocation
>```c
>__shared type variable_name;
>```
## 1D stencil computation
when a stencil is used, each output element is *the sum of the input elements inside a certain radius*:
- if `radius=3`, then each output element is the sum of 7 input elements (3 to the left, 3 to the right, and the current input element)
when using a stencil, input element are read several times
- e.g. with `radius=3`, each input element is read 7 times
the input array is read-only, and the output elements are written in another array, `y`
each thread processes one output element, therefore `blockDim.x` output elements per block are processed

>[!warning] 1D stencil computation is used for image convolution or finite differencing !

the idea is to move from the slow global memory to the faster shared memory.
we also need to address the need, for boundary elements, of “*ghost cells*” to successfully calculate their output value
- we therefore add `radius` cells to the start and the end of the array. the size of the shared memory array is then `blockDim.x + 2 * radius`
we then write the result of the stencil calculation back to the global memory
>[!example] code example
>```c
>// kernel, executed by each thread
>__global__ void stencil_1d(int *in, int *out) {
>	// shared array
>    __shared__ int temp[BLOCK_SIZE + 2 * RADIUS];
>    int gindex = threadIdx.x + blockIdx.x * blockDim.x;
>    int lindex = threadIdx.x + RADIUS;
>
>    // read input elements into shared memory
>    temp[lindex] = in[gindex];
>    if (threadIdx.x < RADIUS) {
>        temp[lindex - RADIUS] = in[gindex - RADIUS];
>        temp[lindex + BLOCK_SIZE] = in[gindex + BLOCK_SIZE];
>    }
>	
>	// apply the stencil (calculate one output element)
>	int result = 0;
>	for (int offset = -RADIUS ; offset <= RADIUS ; offset++)
>		result += temp[lindex + offset];
>	
>	    // store the result
>	    out[gindex] = result;
>}
>```
>- `gindex`: index, relative to the entire `in` array, of the element to be calculated by the current thread
>- `lindex`: index, relative to the `temp`array, of the element to be calculated by the current thread (`RADIUS` is added because the element $i$ of the block $j$ (global array) corresponds to the element $i+\text{RADIUS}$ of the shared memory array)
>
>`in` and `out` should be of the same size, as they both dont have the *halo*

### thread synchronization
what if the first warp of the block gets executed, and thread 31 starts computing the result before thread 32 copies in `temp` the element in position 32 ? (as each thread copies one element in `temp`)
- we need to synchronize the threads, to guarantee that the stencil is applied only after the data has been loaded in the shared memory
>[!syntax] synchronization
the following function synchronizes all threads within a block: all threads must reach the barrier to proceed
>```c
>void __syncthreads()
>```

in the previous example, it would be placed after reading the input elements into shared memory
## grayscale image computation
we can see an image as a 2D matrix of pixels: each pixel has 3 values for the 3 RGB channels, making the image a matrix with 
$$
\text{number of columns = 3 $\cdot$ number of pixels in a row}
$$
the formula to convert a RGB pixel to grayscale is:
$$
L = r \cdot 0.21 + g \cdot 0.72 + b \cdot 0.07
$$
>[!info] parallelization
we can calculate the pixels independently of each other (assigning one pixel to one thread), however, we need to check if the thread actually has a pixel to calculate (as the image can be smaller than the blocks used)
![[Pasted image 20251214131701.png]]

```c
// we have 3 channels corresponding to RGB
// the input image is encoded as unsigned characters [0, 255]
__global__ void colorToGreyscaleConversion(unsigned char * Pout, unsigned char * Pin, int width, int height) {
	// calculate the absolute pixel position, that will be calculated by the thread	
    int Col = threadIdx.x + blockIdx.x * blockDim.x;
    int Row = threadIdx.y + blockIdx.y * blockDim.y;

    if (Col < width && Row < height) {
        // get 1D coordinate for the grayscale image
        int greyOffset = Row * width + Col;
        // one can think of the RGB image having
        // CHANNEL times columns than the grayscale image
        int rgbOffset = greyOffset * CHANNELS;
        unsigned char r = Pin[rgbOffset];     // red value for pixel
        unsigned char g = Pin[rgbOffset + 1]; // green value for pixel
        unsigned char b = Pin[rgbOffset + 2]; // blue value for pixel
        // perform the rescaling and store it
        // We multiply by floating point constants
        Pout[greyOffset] = 0.21f * r + 0.71f * g + 0.07f * b;
    }
}
```

`greyOffset`: index for the element i need to work on, on the linearized array
`CHANNLES` = 3 in quanto ogni pixel ha 3 colori
## blur image computation
## performance estimation
andrebbe specificare con quali elementi faccio operazioni flop