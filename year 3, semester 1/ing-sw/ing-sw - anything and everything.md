---
related to:
created: 2026-01-03, 17:56
updated: 2026-01-03T18:57
completed: false
---
`std::random_device`: non-deterministic generator (used 4 the seed. true randomness but expensive)
`std::default-random-engine`: pseudo-random number generator. it can be used with distributions (fast but mathematically predictable (based on the seed. deterministic))

the course of action is to instantiate a `random_device`, use it to generate a seed for a `default_random_engine`

the logic of generating random numbers is split into *the engine* and *the distribution*