////////////////////////////////////////////////////////////////////////////////
// You're implementing the following function in ARM Assembly
//! C = A * B
//! @param C          result matrix
//! @param A          matrix A 
//! @param B          matrix B
//! @param hA         height of matrix A
//! @param wA         width of matrix A
//! @param wB         width of matrix B
//
//void matmul(int* C, const int* A, const int* B, unsigned int hA, 
//    unsigned int wA, unsigned int wB)
//{
//  for (unsigned int i = 0; i < hA; ++i)
//    for (unsigned int j = 0; j < wB; ++j) {
//      int sum = 0;
//      for (unsigned int k = 0; k < wA; ++k) {
//        sum += A[i * wA + k] * B[j * wB + k];
//      }
//      C[i * wB + j] = sum;
//    }
//}
////////////////////////////////////////////////////////////////////////////////

.arch armv8-a
.global matmul

/*
 * Assumptions needed to make for this program to work:
 *    1. Matrix M is in row major order
 *    2. Matrix N is in column major order
 *    3. Both M and N have equal heights and widths i.e. Square Matrix
 *    4. Both M and N have a total size that is divisible by 4
 *
 * Argument Registers:
 * x0: Return matrix address
 * x1: Matrix A address
 * x2: Matrix B address
 * x3: hA
 * x4: wA
 * x5: wB
 */

.arch armv8-a
.global matmul

matmul:
    // Initial setup
    mov x6, x3       // Move hA to x6 for the outer loop counter
    mov x7, 0        // Initialize outer loop index i to 0

outer_loop:
    cmp x7, x6       // Compare i with hA
    bge end_outer    // If i >= hA, end outer loop

    mov x8, x5       // Move wB to x8 for the inner loop counter
    mov x9, 0        // Initialize inner loop index j to 0

inner_loop:
    cmp x9, x8       // Compare j with wB
    bge end_inner    // If j >= wB, end inner loop

    // Initialize sum accumulator
    eor v0.16b, v0.16b, v0.16b  // Zero out v0 for sum

    mov x10, x4      // Move wA to x10 for dot product loop counter
    mov x11, 0       // Initialize dot product loop index k to 0

dot_product_loop:
    cmp x11, x10     // Compare k with wA
    bge end_dot_product // If k >= wA, end dot product loop

    // Load elements from A and B and multiply
    ld1 {v1.4S}, [x1], #16      // Load 4 elements from A
    ld1 {v2.4S}, [x2], #16      // Load 4 elements from B
    mla v0.4S, v1.4S, v2.4S     // Multiply and accumulate

    add x11, x11, #4   // Increment k
    b dot_product_loop

end_dot_product:
    // Store the result in C
    st1 {v0.4S}, [x0], #16

    add x9, x9, #1     // Increment j
    b inner_loop

end_inner:
    add x7, x7, #1     // Increment i
    b outer_loop

end_outer:
    ret
