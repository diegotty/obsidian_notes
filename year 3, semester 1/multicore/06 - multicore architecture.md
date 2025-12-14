---
related to:
created: 2025-12-10, 14:32
updated: 2025-12-14T09:14
completed: false
---
>[!info] cache
a cache is a collection of memory locations that can be accessed in less time than some other memory locations: it is typically physically very close (usually on the same chip), and uses more performing (and also expensive) technology.
thus is this faster, but smaller (bc expensive)

data in the cache is stored based on *locality*, the principle that access to one location is usually followed by an access of a nearby location. this principle can be applied to space and time:
- *spatial locality*: accessing a nearby location
- *temporal locality*: accessing the location in the near future
>[!example] locality example
```c
float z[1000];

sum = 0.0;
for (i = 0; i < 1000; i++){
	sum += z[i];
}
```
>we can see that:
>- `z[i]` follows `z[i-1]` in memory (spatial locality)
>- accesses to `z[i]` follow access to `z[i-1]` (temporal locality)

