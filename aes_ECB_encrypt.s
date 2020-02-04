.globl AES_ECB_encrypt
AES_ECB_encrypt:
# parameter 1: %rdi
# parameter 2: %rsi
# parameter 3: %rdx
# parameter 4: %rcx
# parameter 5: %r8d
    movq %rdx, %r10
    shrq $4, %rdx
    shlq $60, %r10
    je NO_PARTS_4
    addq $1, %rdx
NO_PARTS_4:
    movq %rdx, %r10
    shlq $62, %r10
    shrq $62, %r10
    shrq $2, %rdx
    je REMAINDER_4
    subq $64, %rsi
LOOP_4:
    movdqu (%rdi), %xmm1
    movdqu 16(%rdi), %xmm2
    movdqu 32(%rdi), %xmm3
    movdqu 48(%rdi), %xmm4
    movdqa (%rcx), %xmm9
    movdqa 16(%rcx), %xmm10
    movdqa 32(%rcx), %xmm11
    movdqa 48(%rcx), %xmm12
    pxor %xmm9, %xmm1
    pxor %xmm9, %xmm2
    pxor %xmm9, %xmm3
    pxor %xmm9, %xmm4
    aesenc %xmm10, %xmm1
    aesenc %xmm10, %xmm2
    aesenc %xmm10, %xmm3
    aesenc %xmm10, %xmm4
    aesenc %xmm11, %xmm1
    aesenc %xmm11, %xmm2
    aesenc %xmm11, %xmm3
    aesenc %xmm11, %xmm4
    aesenc %xmm12, %xmm1
    aesenc %xmm12, %xmm2
    aesenc %xmm12, %xmm3
    aesenc %xmm12, %xmm4
    movdqa 64(%rcx), %xmm9
    movdqa 80(%rcx), %xmm10
    movdqa 96(%rcx), %xmm11
    movdqa 112(%rcx), %xmm12
    aesenc %xmm9, %xmm1
    aesenc %xmm9, %xmm2
    aesenc %xmm9, %xmm3
    aesenc %xmm9, %xmm4
    aesenc %xmm10, %xmm1
    aesenc %xmm10, %xmm2
    aesenc %xmm10, %xmm3
    aesenc %xmm10, %xmm4
    aesenc %xmm11, %xmm1
    aesenc %xmm11, %xmm2
    aesenc %xmm11, %xmm3
    aesenc %xmm11, %xmm4
    aesenc %xmm12, %xmm1
    aesenc %xmm12, %xmm2
    aesenc %xmm12, %xmm3
    aesenc %xmm12, %xmm4
    movdqa 128(%rcx), %xmm9
    movdqa 144(%rcx), %xmm10
    movdqa 160(%rcx), %xmm11
    cmpl $12, %r8d
    aesenc %xmm9, %xmm1
    aesenc %xmm9, %xmm2
    aesenc %xmm9, %xmm3
    aesenc %xmm9, %xmm4
    aesenc %xmm10, %xmm1
    aesenc %xmm10, %xmm2
    aesenc %xmm10, %xmm3
    aesenc %xmm10, %xmm4
    jb LAST_4
    movdqa 160(%rcx), %xmm9
    movdqa 176(%rcx), %xmm10
    movdqa 192(%rcx), %xmm11
    cmpl $14, %r8d
    aesenc %xmm9, %xmm1
    aesenc %xmm9, %xmm2
    aesenc %xmm9, %xmm3
    aesenc %xmm9, %xmm4
    aesenc %xmm10, %xmm1
    aesenc %xmm10, %xmm2
    aesenc %xmm10, %xmm3
    aesenc %xmm10, %xmm4
    jb LAST_4
    movdqa 192(%rcx), %xmm9
    movdqa 208(%rcx), %xmm10
    movdqa 224(%rcx), %xmm11
    aesenc %xmm9, %xmm1
    aesenc %xmm9, %xmm2
    aesenc %xmm9, %xmm3
    aesenc %xmm9, %xmm4
    aesenc %xmm10, %xmm1
    aesenc %xmm10, %xmm2
    aesenc %xmm10, %xmm3
    aesenc %xmm10, %xmm4
LAST_4:
    addq $64, %rdi
    addq $64, %rsi
    decq %rdx
    aesenclast %xmm11, %xmm1
    aesenclast %xmm11, %xmm2
    aesenclast %xmm11, %xmm3
    aesenclast %xmm11, %xmm4
    movdqu %xmm1, (%rsi)
    movdqu %xmm2, 16(%rsi)
    movdqu %xmm3, 32(%rsi)
    movdqu %xmm4, 48(%rsi)
    jne LOOP_4
    addq $64, %rsi
REMAINDER_4:
    cmpq $0, %r10
    je END_4
LOOP_4_2:
    movdqu (%rdi), %xmm1
    addq $16, %rdi
    pxor (%rcx), %xmm1
    movdqu 160(%rcx), %xmm2
    aesenc 16(%rcx), %xmm1
    aesenc 32(%rcx), %xmm1
    aesenc 48(%rcx), %xmm1
    aesenc 64(%rcx), %xmm1
    aesenc 80(%rcx), %xmm1
    aesenc 96(%rcx), %xmm1
    aesenc 112(%rcx), %xmm1
    aesenc 128(%rcx), %xmm1
    aesenc 144(%rcx), %xmm1
    cmpl $12, %r8d
    jb LAST_4_2
    movdqu 192(%rcx), %xmm2
    aesenc 160(%rcx), %xmm1
    aesenc 176(%rcx), %xmm1
    cmpl $14, %r8d
    jb LAST_4_2
    movdqu 224(%rcx), %xmm2
    aesenc 192(%rcx), %xmm1
    aesenc 208(%rcx), %xmm1
LAST_4_2:
    aesenclast %xmm2, %xmm1
    movdqu %xmm1, (%rsi)
    addq $16, %rsi
    decq %r10
    jne LOOP_4_2
END_4:
    ret