.align 16
ONE:
.quad 0x00000000,0x00000001
.align 16
FOUR:
.quad 0x00000000,0x00000004

.globl AES_CTR_encrypt

# function implemented in the style of https://www.intel.com/content/dam/doc/white-paper/advanced-encryption-standard-new-instructions-set-paper.pdf

AES_CTR_encrypt:
# parameter 1: %rdi = const unsigned char* input
# parameter 2: %rsi = unsigned char* output
# parameter 3: %rdx = unsigned char nonce[8]
# parameter 4: %rcx = unsigned long long counter
# parameter 5: %r8  = unsigned long length
# parameter 6: %r9 = unsigned char* key_schedule
# parameter 7: %rsp + 8 = int nr
    pinsrq  $0, (%rdx), %xmm0       # move the nonce in xmm0
    pinsrq  $1, %rcx, %xmm0         # concatenate with the counter

    movl    8(%rsp), %r12d          # copy the number of bytes to encrypt to r12
    shrq    $4, %r8                 # divide by 2^4 = 16 bytes to obtain the number of blocks

    movq    %r8, %r10               # copy the number of blocks to r10
    shlq    $62, %r10               # shift r10 left then right by 62 => r10 = r10 % 4
    shrq    $62, %r10               # the last r10 blocks will be encrypted sequentially

    shrq    $2, %r8                 # divide by 4 to determine the number of iterations
    cmpq    $0, %r8                 # if the number of blocks is 0
    je      REMAINDER               # skip the loop and do the last r10 blocks

    # sub 64 because we will add it later at the beginning of the loop
    subq    $64, %rdi
    subq    $64, %rsi

LOOP:
    # increment block memory locations: 64 = 4 (because we do 4 at a time) * 16 (block size)
    addq    $64, %rdi
    addq    $64, %rsi

    # prepare the blocks to encrypt
    movdqa  %xmm0, %xmm1            # xmm1 = nonce || counter
    paddq   (FOUR), %xmm0           # increment the counter by 4 for the next round

    movdqa  %xmm1, %xmm2            # xmm2 = nonce || counter
    paddq   (ONE), %xmm2            # xmm2 = nonce || counter + 1

    movdqa  %xmm2, %xmm3            # xmm3 = nonce || counter + 1
    paddq   (ONE), %xmm3            # xmm3 = nonce || counter + 2

    movdqa  %xmm3, %xmm4            # xmm4 = nonce || counter + 2
    paddq   (ONE), %xmm4            # xmm4 = nonce || counter + 3

    # round 1: xor
    movdqa  (%r9), %xmm8
    pxor    %xmm8, %xmm1
    pxor    %xmm8, %xmm2
    pxor    %xmm8, %xmm3
    pxor    %xmm8, %xmm4

    # round 2
    movdqa  16(%r9), %xmm8
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # round 3
    movdqa  32(%r9), %xmm8
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # round 4
    movdqa  48(%r9), %xmm8
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # round 5
    movdqa  64(%r9), %xmm8
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # round 6
    movdqa  80(%r9), %xmm8
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # round 7
    movdqa  96(%r9), %xmm8
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # round 8
    movdqa  112(%r9), %xmm8
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # round 9
    movdqa  128(%r9), %xmm8
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # round 10
    movdqa  144(%r9), %xmm8
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # round 11
    movdqa  160(%r9), %xmm8
    cmpl    $12, %r12d              # if r12 is lower than 12
    jl      FINAL_ROUND             # stop doing the next rounds
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # round 12
    movdqa  176(%r9), %xmm8
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # round 13
    movdqa  192(%r9), %xmm8
    cmpl    $12, %r12d              # if r12 is lower than 14
    jl      FINAL_ROUND             # stop doing the next rounds
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # round 14
    movdqa  208(%r9), %xmm8
    aesenc  %xmm8, %xmm1
    aesenc  %xmm8, %xmm2
    aesenc  %xmm8, %xmm3
    aesenc  %xmm8, %xmm4

    # key schedule for roound 15
    movdqa  224(%r9), %xmm8

FINAL_ROUND:
    aesenclast  %xmm8, %xmm1
    aesenclast  %xmm8, %xmm2
    aesenclast  %xmm8, %xmm3
    aesenclast  %xmm8, %xmm4

    # xor with the plaintext to obtain cyphertext
    pxor    (%rdi), %xmm1
    pxor    16(%rdi), %xmm2
    pxor    32(%rdi), %xmm3
    pxor    48(%rdi), %xmm4

    # move the cyphertext to the output
    movdqu  %xmm1, (%rsi)
    movdqu  %xmm2, 16(%rsi)
    movdqu  %xmm3, 32(%rsi)
    movdqu  %xmm4, 48(%rsi)

    decq    %r8                     # decrement counter
    jne     LOOP                    # if it is not 4, go back to the loop

    # else increment the pointers and do the sequential part
    addq    $64, %rdi
    addq    $64, %rsi

REMAINDER:
    cmpq    $0, %r10                # if there are no remainder blocks to do
    je      END

REMAINDER_LOOP:
    movdqa  %xmm0, %xmm1            # use xmm1 to encrypt
    paddq   (ONE), %xmm0            # increment counter

    pxor    (%r9), %xmm1            # round 1
    aesenc  16(%r9), %xmm1
    aesenc  32(%r9), %xmm1
    aesenc  48(%r9), %xmm1
    aesenc  64(%r9), %xmm1
    aesenc  80(%r9), %xmm1
    aesenc  96(%r9), %xmm1
    aesenc  112(%r9), %xmm1
    aesenc  128(%r9), %xmm1
    aesenc  144(%r9), %xmm1
    movdqa  160(%r9), %xmm8         # store this in xmm8 for the last round
    cmpl    $12, %r12d
    jl      REMAINDER_FINAL_ROUND
    aesenc  160(%r9), %xmm1
    aesenc  176(%r9), %xmm1
    movdqa  192(%r9), %xmm8         # store this in xmm8 for the last round
    cmpl    $14, %r12d
    jl      REMAINDER_FINAL_ROUND
    aesenc  192(%r9), %xmm1
    aesenc  208(%r9), %xmm1
    movdqa  224(%r9), %xmm8         # store this in xmm8 for the last round

REMAINDER_FINAL_ROUND:
    aesenclast  %xmm8, %xmm1        # do last round with the set value in xmm8
    pxor    (%rdi), %xmm1           # xor with plaintext to obtain cyphertext
    movdqu  %xmm1, (%rsi)           # copy the encrypted block to memory
    # increment memory pointers
    addq    $16, %rdi
    addq    $16, %rsi

    decq    %r10                    # decrement the number of rounds left
    jne     REMAINDER_LOOP          # if there are rounds left go back to the loop

END:
    ret
