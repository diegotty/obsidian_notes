---
related to:
created: 2025-11-25, 17:14
updated: 2025-11-25T17:37
completed: false
---
# CUDA
## CPU vs GPU

*CPU*s are *latency oriented* (high clock frequency)
*GPU*s are *throughput oriented* (). to optimize so, it features:
WARP (32 core) hanno la stessa CU 
- i core della GPU sono + semplici perchè hanno meno CU
- bandwith + alta (x vram)

SMs on the same building block share chache and texture memory


northbridge: pci express
in architectures a and b we need to take account of the fact that to do calculations on the GPU we need to move the data from the Ram to the GPU and back