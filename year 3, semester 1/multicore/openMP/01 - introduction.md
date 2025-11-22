---
related to:
created: 2025-11-22, 18:09
updated: 2025-11-22T19:16
completed: false
---
*OpenMP* is an API for shared-memory parallel programming. it aims to decompose a sequential program into components that can be executed in parallel.
- the system is viewed as a collection of cores or CPU’s, all of which have access to main memory.
- MP stands for multiprocessing

openMP allows for *incremental conversion* of the sequential programs, by targeting hotspots (instead of re-writing the entire program) and adding directives to such code-blocks