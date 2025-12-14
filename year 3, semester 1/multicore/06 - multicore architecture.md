---
related to:
created: 2025-12-10, 14:32
updated: 2025-12-14T09:59
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
#### directory-based cache coherence
this method to ensure cache coherence uses a data structure called *directory*, that stores the status of each cache line.
>[!warning] this example co
when a variable is updated:
- the directory is consulted by the core that decides to update
- the directory consults its list and finds the cores that have a copy of the block in *their caches*.
- and the cache controllers of the cores that have that variable’s cache line in the caches are *invalidated*
- the directory is usually located in the *memory controller* or the L3 cache
- e.g.: a bitmap saying which cores have a copy of a given line, and whether the line is clean or dirty