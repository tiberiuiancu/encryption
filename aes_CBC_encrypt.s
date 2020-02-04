.globl AES_CBC_encrypt
AES_CBC_encrypt:
# parameter 1: %rdi
# parameter 2: %rsi
# parameter 3: %rdx
# parameter 4: %rcx
# parameter 5: %r8
# parameter 6: %r9d
    movq %rcx, %r10
    shrq $4, %rcx
    shlq $60, %r10
    je NO_PARTS
    addq $1, %rcx
NO_PARTS:
    subq $16, %rsi
    movdqa (%rdx), %xmm1
LOOP:
    pxor (%rdi), %xmm1
    pxor (%r8), %xmm1
    addq $16,%rsi
    addq $16,%rdi
    cmpl $12, %r9d
    aesenc 16(%r8),%xmm1
    aesenc 32(%r8),%xmm1
    aesenc 48(%r8),%xmm1
    aesenc 64(%r8),%xmm1
    aesenc 80(%r8),%xmm1
    aesenc 96(%r8),%xmm1
    aesenc 112(%r8),%xmm1
    aesenc 128(%r8),%xmm1
    aesenc 144(%r8),%xmm1
    movdqa 160(%r8),%xmm2
    jb LAST
    cmpl $14, %r9d
    aesenc 160(%r8),%xmm1
    aesenc 176(%r8),%xmm1
    movdqa 192(%r8),%xmm2
    jb LAST
    aesenc 192(%r8),%xmm1
    aesenc 208(%r8),%xmm1
    movdqa 224(%r8),%xmm2
LAST:
    decq %rcx
    aesenclast %xmm2,%xmm1
    movdqu %xmm1,(%rsi)

    jne LOOP
    ret