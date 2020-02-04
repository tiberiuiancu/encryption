.globl AES_192_Key_Expansion, AES_192_Inverse_Key_Expansion
AES_192_Key_Expansion:
# parameter 1: %rdi
# parameter 2: %rsi
    movdqu (%rdi), %xmm1
    movdqu 16(%rdi), %xmm3
    movdqa %xmm1, (%rsi)
    movdqa %xmm3, %xmm5

    aeskeygenassist $0x1, %xmm3, %xmm2
    call PREPARE_ROUNDKEY_192
    shufpd $0, %xmm1, %xmm5
    movdqa %xmm5, 16(%rsi)
    movdqa %xmm1, %xmm6
    shufpd $1, %xmm3, %xmm6
    movdqa %xmm6, 32(%rsi)

    aeskeygenassist $0x2, %xmm3, %xmm2
    call PREPARE_ROUNDKEY_192
    movdqa %xmm1, 48(%rsi)
    movdqa %xmm3, %xmm5

    aeskeygenassist $0x4, %xmm3, %xmm2
    call PREPARE_ROUNDKEY_192
    shufpd $0, %xmm1, %xmm5
    movdqa %xmm5, 64(%rsi)
    movdqa %xmm1, %xmm6
    shufpd $1, %xmm3, %xmm6
    movdqa %xmm6, 80(%rsi)

    aeskeygenassist $0x8, %xmm3, %xmm2
    call PREPARE_ROUNDKEY_192
    movdqa %xmm1, 96(%rsi)
    movdqa %xmm3, %xmm5

    aeskeygenassist $0x10, %xmm3, %xmm2
    call PREPARE_ROUNDKEY_192
    shufpd $0, %xmm1, %xmm5
    movdqa %xmm5, 112(%rsi)
    movdqa %xmm1, %xmm6
    shufpd $1, %xmm3, %xmm6
    movdqa %xmm6, 128(%rsi)

    aeskeygenassist $0x20, %xmm3, %xmm2
    call PREPARE_ROUNDKEY_192
    movdqa %xmm1, 144(%rsi)
    movdqa %xmm3, %xmm5

    aeskeygenassist $0x40, %xmm3, %xmm2
    call PREPARE_ROUNDKEY_192
    shufpd $0, %xmm1, %xmm5
    movdqa %xmm5, 160(%rsi)
    movdqa %xmm1, %xmm6
    shufpd $1, %xmm3, %xmm6
    movdqa %xmm6, 176(%rsi)

    aeskeygenassist $0x80, %xmm3, %xmm2
    call PREPARE_ROUNDKEY_192
    movdqa %xmm1, 192(%rsi)
    ret

PREPARE_ROUNDKEY_192:
    pshufd $0x55, %xmm2, %xmm2
    movdqu %xmm1, %xmm4
    pslldq $4, %xmm4
    pxor %xmm4, %xmm1
    pslldq $4, %xmm4
    pxor %xmm4, %xmm1
    pslldq $4, %xmm4
    pxor %xmm4, %xmm1
    pxor %xmm2, %xmm1
    pshufd $0xff, %xmm1, %xmm2
    movdqu %xmm3, %xmm4
    pslldq $4, %xmm4
    pxor %xmm4, %xmm3
    pxor %xmm2, %xmm3
    ret

AES_192_Inverse_Key_Expansion:
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

    movdqa %xmm1, 192(%rsi)
    movdqa %xmm2, 176(%rsi)
    movdqa %xmm3, 160(%rsi)
    movdqa %xmm4, 144(%rsi)
    movdqa %xmm5, 128(%rsi)
    movdqa %xmm6, 112(%rsi)
    movdqa %xmm7, 96(%rsi)
    movdqa %xmm8, 80(%rsi)
    movdqa %xmm9, 64(%rsi)
    movdqa %xmm10, 48(%rsi)
    movdqa %xmm11, 32(%rsi)
    movdqa %xmm12, 16(%rsi)
    movdqa %xmm13, (%rsi)

    ret

