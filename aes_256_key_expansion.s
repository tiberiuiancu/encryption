.globl AES_256_Key_Expansion, AES_256_Inverse_Key_Expansion
AES_256_Key_Expansion:
# parameter 1: %rdi
# parameter 2: %rsi
    movdqu (%rdi), %xmm1
    movdqu 16(%rdi), %xmm3
    movdqa %xmm1, (%rsi)
    movdqa %xmm3, 16(%rsi)

    aeskeygenassist $0x1, %xmm3, %xmm2
    call MAKE_RK256_a
    movdqa %xmm1, 32(%rsi)
    aeskeygenassist $0x0, %xmm1, %xmm2
    call MAKE_RK256_b
    movdqa %xmm3, 48(%rsi)
    aeskeygenassist $0x2, %xmm3, %xmm2
    call MAKE_RK256_a
    movdqa %xmm1, 64(%rsi)
    aeskeygenassist $0x0, %xmm1, %xmm2
    call MAKE_RK256_b
    movdqa %xmm3, 80(%rsi)
    aeskeygenassist $0x4, %xmm3, %xmm2
    call MAKE_RK256_a
    movdqa %xmm1, 96(%rsi)
    aeskeygenassist $0x0, %xmm1, %xmm2
    call MAKE_RK256_b
    movdqa %xmm3, 112(%rsi)
    aeskeygenassist $0x8, %xmm3, %xmm2
    call MAKE_RK256_a
    movdqa %xmm1, 128(%rsi)
    aeskeygenassist $0x0, %xmm1, %xmm2
    call MAKE_RK256_b
    movdqa %xmm3, 144(%rsi)
    aeskeygenassist $0x10, %xmm3, %xmm2
    call MAKE_RK256_a
    movdqa %xmm1, 160(%rsi)
    aeskeygenassist $0x0, %xmm1, %xmm2
    call MAKE_RK256_b
    movdqa %xmm3, 176(%rsi)
    aeskeygenassist $0x20, %xmm3, %xmm2
    call MAKE_RK256_a
    movdqa %xmm1, 192(%rsi)
    aeskeygenassist $0x0, %xmm1, %xmm2
    call MAKE_RK256_b
    movdqa %xmm3, 208(%rsi)
    aeskeygenassist $0x40, %xmm3, %xmm2
    call MAKE_RK256_a
    movdqa %xmm1, 224(%rsi)

    ret

MAKE_RK256_a:
    pshufd $0xff, %xmm2, %xmm2
    movdqa %xmm1, %xmm4
    pslldq $4, %xmm4
    pxor %xmm4, %xmm1
    pslldq $4, %xmm4
    pxor %xmm4, %xmm1
    pslldq $4, %xmm4
    pxor %xmm4, %xmm1
    pxor %xmm2, %xmm1
    ret

MAKE_RK256_b:
    pshufd $0xaa, %xmm2, %xmm2
    movdqa %xmm3, %xmm4
    pslldq $4, %xmm4
    pxor %xmm4, %xmm3
    pslldq $4, %xmm4
    pxor %xmm4, %xmm3
    pslldq $4, %xmm4
    pxor %xmm4, %xmm3
    pxor %xmm2, %xmm3
    ret

AES_256_Inverse_Key_Expansion:
# parameter 1: %rdi
# parameter 2: %rsi
    movdqu (%rdi), %xmm1
    movdqu 16(%rdi), %xmm2
    movdqu 32(%rdi), %xmm3
    movdqu 48(%rdi), %xmm4
    movdqu 64(%rdi), %xmm5
    movdqu 80(%rdi), %xmm6
    movdqu 96(%rdi), %xmm7
    movdqu 112(%rdi), %xmm8
    movdqu 128(%rdi), %xmm9
    movdqu 144(%rdi), %xmm10
    movdqu 160(%rdi), %xmm11
    movdqu 176(%rdi), %xmm12
    movdqu 192(%rdi), %xmm13
    movdqu 208(%rdi), %xmm14
    movdqu 224(%rdi), %xmm15

    aesimc %xmm2, %xmm2
    aesimc %xmm3, %xmm3
    aesimc %xmm4, %xmm4
    aesimc %xmm5, %xmm5
    aesimc %xmm6, %xmm6
    aesimc %xmm7, %xmm7
    aesimc %xmm8, %xmm8
    aesimc %xmm9, %xmm9
    aesimc %xmm10, %xmm10
    aesimc %xmm11, %xmm11
    aesimc %xmm12, %xmm12
    aesimc %xmm13, %xmm13
    aesimc %xmm14, %xmm14

    movdqa %xmm1, 224(%rsi)
    movdqa %xmm2, 208(%rsi)
    movdqa %xmm3, 192(%rsi)
    movdqa %xmm4, 176(%rsi)
    movdqa %xmm5, 160(%rsi)
    movdqa %xmm6, 144(%rsi)
    movdqa %xmm7, 128(%rsi)
    movdqa %xmm8, 112(%rsi)
    movdqa %xmm9, 96(%rsi)
    movdqa %xmm10, 80(%rsi)
    movdqa %xmm11, 64(%rsi)
    movdqa %xmm12, 48(%rsi)
    movdqa %xmm13, 32(%rsi)
    movdqa %xmm14, 16(%rsi)
    movdqa %xmm15, (%rsi)

    ret
