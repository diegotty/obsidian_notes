---
related to: "[[06 - caches and multicore memory architectures]]"
created: 2026-02-26, 08:05
updated: 2026-02-26T08:09
completed: false
---
`cudaMemcpy()` uses *DMA* (direct memory access) hardware [[dispositivi IO, buffering#DMA|(os1)]] for better efficiency (as it frees the CPU for other tasks)
>[!info] illustration
![[Pasted image 20260226080907.png]]
