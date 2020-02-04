.align 16,0x90
.globl AES_128_Key_Expansion, AES_128_Inverse_Key_Expansion
AES_128_Key_Expansion:
# parameter 1: %rdi
# parameter 2: %rsi
    movl $10, 240(%rsi)
    movdqu (%rdi), %xmm1
    movdqa %xmm1, (%rsi)

ASSISTS:
    aeskeygenassist $1, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
    movdqa %xmm1, 16(%rsi)
    aeskeygenassist $2, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
    movdqa %xmm1, 32(%rsi)
    aeskeygenassist $4, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
    movdqa %xmm1, 48(%rsi)
    aeskeygenassist $8, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
    movdqa %xmm1, 64(%rsi)
    aeskeygenassist $16, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
    movdqa %xmm1, 80(%rsi)
    aeskeygenassist $32, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
    movdqa %xmm1, 96(%rsi)
    aeskeygenassist $64, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
    movdqa %xmm1, 112(%rsi)
    aeskeygenassist $0x80, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
    movdqa %xmm1, 128(%rsi)
    aeskeygenassist $0x1b, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
    movdqa %xmm1, 144(%rsi)
    aeskeygenassist $0x36, %xmm1, %xmm2
    call PREPARE_ROUNDKEY_128
    movdqa %xmm1, 160(%rsi)
    ret

PREPARE_ROUNDKEY_128:
    pshufd $255, %xmm2, %xmm2
    movdqa %xmm1, %xmm3
    pslldq $4, %xmm3
    pxor %xmm3, %xmm1
    pslldq $4, %xmm3
    pxor %xmm3, %xmm1
    pslldq $4, %xmm3
    pxor %xmm3, %xmm1
    pxor %xmm2, %xmm1
    ret

AES_128_Inverse_Key_Expansion:
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

    aesimc %xmm2, %xmm2
    aesimc %xmm3, %xmm3
    aesimc %xmm4, %xmm4
    aesimc %xmm5, %xmm5
    aesimc %xmm6, %xmm6
    aesimc %xmm7, %xmm7
    aesimc %xmm8, %xmm8
    aesimc %xmm9, %xmm9
    aesimc %xmm10, %xmm10

    movdqa %xmm1, 160(%rsi)
    movdqa %xmm2, 144(%rsi)
    movdqa %xmm3, 128(%rsi)
    movdqa %xmm4, 112(%rsi)
    movdqa %xmm5, 96(%rsi)
    movdqa %xmm6, 80(%rsi)
    movdqa %xmm7, 64(%rsi)
    movdqa %xmm8, 48(%rsi)
    movdqa %xmm9, 32(%rsi)
    movdqa %xmm10, 16(%rsi)
    movdqa %xmm11, (%rsi)

    ret
