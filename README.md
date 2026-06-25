# Overview

This is a CPE 315 Computer Architecture project at Cal Poly exploring parallel matrix multiplication using SIMD and OpenMP. Implemented in ARMv8-A assembly, the project measures and analyzes the performance gains achieved through data-level parallelism (SIMD) and multithreading

### SIMD (Single Instruction Multiple Data)
- **Description**: Uses ARM NEON instructions to perform multiple operations in parallel. Well-suited for matrix multiplication where the same arithmetic is applied across large data sets.

### OpenMP Multithreading
- **Description**: OpenMP uses multiple CPU cores to execute matrix multiplication concurrently, reducing overall computation time.

## Performance Measurements

### Runtime Results

- **SIMD Runtime**:
  - 1 Thread: 42.538 s
  - 2 Threads: 22.914 s
  - 4 Threads: 11.672 s
  - 8 Threads: 7.284 s
  - 16 Threads: 7.041 s
  - 32 Threads: 7.189 s
  - 64 Threads: 7.463 s

- **OpenMP Runtime**:
  - 1 Thread: 66.247 s
  - 2 Threads: 36.482 s
  - 4 Threads: 19.853 s
  - 8 Threads: 12.417 s
  - 16 Threads: 11.982 s
  - 32 Threads: 12.106 s
  - 64 Threads: 12.389 s

### Measuring Execution Time and Cache Metrics

- **Tool**: Unix `time` command  
- **Usage**:
  ```bash
  time ./mm > myout
