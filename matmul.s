////////////////////////////////////////////////////////////////////////////////
// You're implementing the following function in ARM Assembly
//! C = A * B
//! @param C          result matrix
//! @param A          matrix A 
//! @param B          matrix B
//! @param hA         height of matrix A
//! @param wA         width of matrix A, height of matrix B
//! @param wB         width of matrix B
//
//  Note that while A, B, and C represent two-dimensional matrices,
//  they have all been allocated linearly. This means that the elements
//  in each row are sequential in memory, and that the first element
//  of the second row immedialely follows the last element in the first
//  row, etc. 
//
//void matmul(int* C, const int* A, const int* B, unsigned int hA, 
//    unsigned int wA, unsigned int wB)
//{
//  for (unsigned int i = 0; i < hA; ++i)
//    for (unsigned int j = 0; j < wB; ++j) {
//      int sum = 0;
//      for (unsigned int k = 0; k < wA; ++k) {
//        sum += A[i * wA + k] * B[k * wB + j];
//      }
//      C[i * wB + j] = sum;
//    }
//}
//
//  NOTE: This version should use the MUL/MLA and ADD instructions
//
////////////////////////////////////////////////////////////////////////////////

	.arch armv8-a
	.global matmul

matC .req x20    // matrix C pointer
matA .req x21    // matrix A pointer
matB .req x22    // matrix B pointer

tempA .req w9     // store matrix location
tempB .req w10    // store matrix location
tempC .req w11    // store matrix location

hA .req x23    // height A
wA .req x24    // width A, height A
wB .req x25    // width B
ci .req x26    // hA counter
cj .req x27    // wB counter
ck .req x28    // wA counter

sum .req x19   // temp sum, resets to 0

matmul:    // EDIT THIS INIT
  	stp x29, x30, [sp,-96]!   // push stack EDIT
  	mov x29, sp               // set fp
  	str matC, [sp, 16]
  	str matA, [sp, 24]
  	str matB, [sp, 32]
  	str hA, [sp, 40]
	str wA, [sp, 48]
	str wB, [sp, 56]
	str ci, [sp, 64]
	str cj, [sp, 72]
	str ck, [sp, 80]

	// move from input
  	mov matC, x0
	mov matA, x1
	mov matB, x2
	mov hA, x3
	mov wA, x4
	mov wB, x5

  	mov ci, #0    // i = 0

outer:   // for (unsigned int i = 0; i < hA; ++i)
	ldr w0, [x29, 64]    // ld int i
	ldr w1, [x29, 40]    // ld hA
	cmp w0, w1    // i < hA
	bgt exit_outer

	mov cj, #0    // j = 0

middle:
	ldr w0, [x29, 72]    // ld int j
	ldr w1, [x29, 56]    // ld wB
	cmp w0, w1    // j < wB
	bgt exit_middle

	mov sum, #0    // sum = 0
	mov ck, #0    // k = 0

inner:
	ldr w0, [x29, 80]    // ld int k
	ldr w1, [x29, 48]    // ld wA
	cmp w0, w1    // k < wA
	bgt exit_inner


	// Matrix A
    // mov x0, ci
	ldr w0, [x29, 64]    // ld int i
	// mov x1, wA
	ldr w1, [x29, 48]    // ld wA
	mul w0, w0, w1

	// mov x1, ck
	// w0 = i * wA
	ldr w1, [x29, 80]    // ld int k
	add w0, w0, w1    // (i * wA) + k
	mov tempA, w0
	

	// Matrix B
	ldr w0, [x29, 80] // ld int k
	ldr w1, [x29, 56] // ld wB
	mul w0, w0, w1    // k * wB

	ldr w1, [x29, 72] // ld int j
	add w0, w0, w1    // k * wB + j
	mov tempB, w0

	ldr w0, [matA, x9, lsl #2]
	ldr w1, [matB, x10, lsl #2]
	mul w0, w0, w1

	mov w1, w19
	add w0, w0, w1

	// increment k
	mov x0, ck   // load from callee/stack
	mov x1, #1
	add w0, w0, w1    // k++
	mov ck, x0
	b inner

exit_inner:
	// C[]
	ldr w0, [x29, 64]
	ldr w1, [x29, 56]
	mul w0, w0, w1    // i * wB

	// w0 = i * wB
	ldr w1, [x29, 72]
	add w0, w0, w1    // i * wB + j
	mov tempC, w0

	str w19, [matC, x11, lsl #2]
	// increment j
	ldr w0, [x29, 72]
	mov w1, #1
	add w0, w0, w1    // j++
	mov cj, x0
	b middle

exit_middle:
	// increment i
	// mov x0, ci
	ldr w0, [x29, 64]
	mov w1, #1
	add w0, w0, w1    // i++
	mov ci, x0
	b outer

exit_outer:
	/* Restore Registers */
    ldr matC, [sp, 16]
    ldr matA, [sp, 24]
    ldr matB, [sp, 32] 
    ldr hA, [sp, 40]
    ldr wA, [sp, 48]
    ldr wB, [sp, 56]
    ldr ci, [sp, 64]
    ldr cj, [sp, 72]
    ldr ck, [sp, 80]
    ldp x29, x30, [sp], 96 
    ret