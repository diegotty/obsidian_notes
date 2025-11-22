---
related to: "[[04 - processes and threads]]"
created: 2025-11-22, 18:09
updated: 2025-11-22T19:20
completed: false
---
# openMP
*OpenMP* is an API for shared-memory parallel programming. it aims to decompose a sequential program into components that can be executed in parallel.
- the system is viewed as a collection of cores or CPU’s, all of which have access to main memory.
- MP stands for multiprocessing

openMP allows for *incremental conversion* of the sequential programs, by targeting hotspots (instead of re-writing the entire program) and adding directives to such code-blocks
it also relies on *compiler directives*: special, non-standard language constructs that are ignored by a standard compiler but recognized and interpreted by an openMP-aware compiler
- an example of compiler directives are *pragmas*

openMP programs are [[02 - parallel design patterns#GSLP|globally sequential, locally parallel]] (and it makes complete sense)

## pragmas
the most basic parallel directive is 
```c
# pragma omp parallel
```