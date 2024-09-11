# Performance Analysis of Parallel Matrix Multiplication

## Introduction

A project for CPE 315 Computer Architecture from California Polytechnic State University. This lab examines the performance enhancements achieved by parallelizing matrix multiplication using two strategies: Single Instruction, Multiple Data (SIMD) and Multithreading with OpenMP. The experiments were conducted using ARMv8-A assembly language, demonstrating the efficiency of SIMD for simultaneous operations and OpenMP for leveraging multiple CPU threads. The focus was on the impact of these parallelization techniques on computation speed in matrix multiplication.

## Objective

The primary aim of this experiment is to investigate and quantify the performance improvements in matrix multiplication through parallelization. Matrix multiplication, a fundamental operation in many scientific and engineering applications, can be computationally intensive. By using parallel computing techniques, we aim to enhance the efficiency and speed of this operation.

## Parallelization Strategies

### Single Instruction, Multiple Data (SIMD)

- **Description**: SIMD involves using ARM's NEON instructions to perform multiple operations simultaneously. This technique is effective for operations like matrix multiplication where the same operation (multiplication and addition) is performed across many data elements.

### Multithreading with OpenMP

- **Description**: OpenMP leverages multiple CPU cores to execute parts of the matrix multiplication process concurrently. By dividing the task among several threads, computation time can be significantly reduced.

## Performance Measurements

### Runtime Results

- **SIMD Runtime**:
  - 1 Thread: 65.361 s
  - 2 Threads: 41.955 s
  - 4 Threads: 24.186 s
  - 8 Threads: 15.334 s
  - 16 Threads: 10.248 s
  - 32 Threads: 7.787 s
  - 64 Threads: 6.685 s

- **OpenMP Runtime**:
  - 1 Thread: 66.249 s
  - 2 Threads: 41.738 s
  - 4 Threads: 25.426 s
  - 8 Threads: 15.825 s
  - 16 Threads: 11.857 s
  - 32 Threads: 9.304 s
  - 64 Threads: 8.132 s

### Measuring Execution Time and Cache Metrics

- **Tool Used**: We used the `time` command on a Unix-like system to measure execution time and cache performance.
- **Command Syntax**: 
  ```bash
  time ./mm > myout
