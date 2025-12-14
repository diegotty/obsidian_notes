---
related to:
created: 2025-12-10, 14:32
updated: 2025-12-14T11:22
completed: false
---
## caches
>[!info] cache
a cache is a collection of memory locations that can be accessed in less time than some other memory locations: it is typically physically very close (usually on the same chip), and uses more performing (and also expensive) technology.
thus is this faster, but smaller (bc expensive)

data in the cache is stored based on *locality*, the principle that access to one location is usually followed by an access of a nearby location. this principle can be applied to space and time:
- *spatial locality*: accessing a physically nearby location in memory
- *temporal locality*: accessing the location in the near future
>[!example] locality example
>```c
>float z[1000];
>
>sum = 0.0;
>for (i = 0; i < 1000; i++){
>	sum += z[i];
>}
>>```
>we can see that:
>- `z[i]` follows `z[i-1]` in memory (spatial locality, as C stores arrays in contiguous memory locations)
>- accesses to `z[i]` follow access to `z[i-1]` (temporal locality)

data is transferred from memory to the cache in *blocks/lines*
>[!example] example of cache line
>when `z[0]` is transferred from memory to cache, also `z[1]`, `z[2]`, `z[3]`, … `z[15]` might be transferred to the cache aswell
*doing one transfer of 16 memory locations is much better than doing 16 transfers of one memory location each* !
- paying a little delay (the bigger transfer) when accessing `z[0]` is worth the wait, as you will find the other 15 elements in the cache already
>[!info] cache levels
![[Pasted image 20251214092155.png]]
>- data stored in L1 might or might not be stored in L2/L3 aswell !

>[!warning] programmers have no control over caches and when they get updated !
the CPU checks the caches in order (L1 first, L2 second, …)
- if it finds the data in a cache (*cache HIT*), it loads it from there
- otherwise (*cache MISS*) it moves to the next memory (L1, L2, L3 and main memory). if it finds it in the main memory, we get a *main memory HIT*
>[!warning] effects on parallel programming
to write efficient & performant parallel code:
>- its sequential parts must be efficient/performant: the accesses to the data should be linear, not random
>- the coordination between these sequential parts must be done efficiently
### consistency
when a CPU writes data to cache, the value in the memory may be *inconsistent* with the value in the main memory. the two main ways to deal with this are:
- *write-through*: caches update the data in the main memory at the time it is written to cache
- *write-back*: caches mark data in the cache as *dirty*, and when the cache line is replaced by a new one from memory, the *dirty* line is written to memory

>[!example] inconsitency example
![[Pasted image 20251214092749.png]]

## caching on multicores
### cache coherence
>[!example] cache coherence example
![[Pasted image 20251214093352.png]]

as we studied, the cores share a bus: any signal transmitted on the bus can be “seen” by all cores connected to the bus:
- when core 0 updates the copy of `x` stored in its cache, it also *broadcasts* this information across the bus
- if core 1 is *snooping* (listening to) the bus, it will see that `x` has been updated and it can mark its copy of `x` as invalid
however, this technolgy is not used anymore, as broadcast is expensive and architectures have too many cores

>[!warning] thus, the follow examples and solution cover the situation where cores have the same variable stored in their own private caches
#### directory-based cache coherence
this method to ensure cache coherence uses a data structure called *directory*, that stores the status of each cache line (e.g a bitmap saying which cores have a copy of a given line, and whether the line is clean or dirty)
when a variable is updated:
- the directory is consulted by the core that decides to update (core A)
- the directory consults its list and finds the cores that have a copy of the block in *their caches*.
	 - the directory sends an *invalidation signal* to the cache controllers of those cores, who receive the signal and mark their copy as *invalid*
- the next time a core with an invalid line try to read the that invalid line, they are forced to fetch the new, correct value from main memory or core A’s cache
the directory is usually located in the *memory controller* or the L3 cache
#### false sharing
data is fetcheed from memory to cache in lines that can contain several variables, depending on the the lines’s length (typically 64 bytes).
*false sharing* happens when two threads access *two different variables taht happend to reside in the same cache line*. this is a problem as it leads to many unneeded cache misses therefore many more loads from memory
>[!example]
a cache line holds two variables (among others): `t1_data` and `t2_data`, and both core A and core B store that line in their cache

- core A (running thread 1) modifies `t1_data`, marking the entire line that contains it as *dirty*
-  the coherence protocol invalides the entire line for core B
- core B (running thread 2) tries to modify `t2_data`: since the cache line was invalidated, it must incur in a costly *cache miss*, and fetch a fresh copy of the entire line
- the same happens to core A after coreB modifies `t2_data`, starting a cycle that repeats endlessly: every time core A writes, core B’s cache is invalidated, and viceversa
to fix false sharing, we can:
- try to force variables which are accessed by different threads to be on different cache lines
- *pad the data* (waste of cache space)
- compiler directives or language features to ensure arrays/structures start on a cache line boundary
- *use private variables*: do all updates on a variable local to the thread, then update the shared variables only at the end
>[!syntax] cache line info
from the code:
>```c
>sysconf(_SC_LEVEL1_DCACHE_LINESIZE);
>```
>
>from the shell:
>```sh
>getconf LEVEL1_DCACHE_LINESIZE
>```

### matrix-vector multiplication example
>[!example] time analysis
the all three cases, we perform the same number of operations (64.000.000), however, the performance changes noticeably between the tree matrix size distributions:
![[Pasted image 20251214110741.png]]

- *8 x 8.000.000*: the input vector `x` has 8.000.000 elements, which means there will be many cache misses when calculating a single `y[i]`
- *8.000.000 x 8*: the output vector `y` has 8.000.000 elements, rather than 8.000. this implies more cache misses, as when you load a `y[i]`, you only use it for 8 operations before needing to load the next `y[i]`
- *8.000 x 8.000*: this distribution balances the amount of time for which we can keep `y[i]` in the cache (8.000) operations, 



![[Pasted image 20251214111213.png]]
as we can see, the efficiency of the multithread version is much worse for *8 x 8.000.000*, because:
- the entire output vector `y` , assuming it is a vector of floats (8 bytes) fits in a line. therefore, if each thread tried to access a different `y[i]`, there would be any false sharing issues, since they are all located in the same cache line
false sharing softens as the number of rows gets larger, as in the *8.00 x 8.000*