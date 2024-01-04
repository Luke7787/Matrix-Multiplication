.global matmul
matmul:
    // Arguments: X0 = C, X1 = A, X2 = B, X3 = hA, X4 = wA, X5 = wB

    // Registers
    // X6 = i, X7 = j, X8 = k, X9 = sum, X10 = temp

    // Outer loop (i)
    mov X6, 0          // Initialize i to 0
outer_loop:
    cmp X6, X3         // Compare i with hA
    bge end_outer      // If i >= hA, exit loop

    // Middle loop (j)
    mov X7, 0          // Initialize j to 0
middle_loop:
    cmp X7, X5         // Compare j with wB
    bge end_middle     // If j >= wB, exit loop

    // Initialize sum to 0
    mov X9, 0

    // Inner loop (k)
    mov X8, 0          // Initialize k to 0
inner_loop:
    cmp X8, X4         // Compare k with wA
    bge end_inner      // If k >= wA, exit loop

    // Calculate sum += A[i * wA + k] * B[k * wB + j]
    ldr W10, [X1, X8, lsl #2]   // Load A[i * wA + k]
    ldr W11, [X2, X7, lsl #2]   // Load B[k * wB + j]
    mul W10, W10, W11           // W10 = A[i * wA + k] * B[k * wB + j]
    add X9, X9, W10             // sum += temp

    // Increment k
    add X8, X8, 1
    b inner_loop

end_inner:
    // Store result in C[i * wB + j]
    str W9, [X0, X7, lsl #2]

    // Increment j
    add X7, X7, 1
    b middle_loop

end_middle:
    // Increment i
    add X6, X6, 1
    b outer_loop

end_outer:
    ret