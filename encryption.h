#ifndef AES_ENCRYPTION_ENCRYPTION_H
#define AES_ENCRYPTION_ENCRYPTION_H

#include <cstdlib>
#include <cstdio>
#include <unistd.h>

extern "C" void AES_128_Key_Expansion(const unsigned char* userkey, unsigned char* key_schedule);
extern "C" void AES_192_Key_Expansion(const unsigned char* userkey, unsigned char* key_schedule);
extern "C" void AES_256_Key_Expansion(const unsigned char* userkey, unsigned char* key_schedule);

extern "C" void AES_128_Inverse_Key_Expansion(const unsigned char* key_schedule, unsigned char* inverse_schedule);
extern "C" void AES_192_Inverse_Key_Expansion(const unsigned char* key_schedule, unsigned char* inverse_schedule);
extern "C" void AES_256_Inverse_Key_Expansion(const unsigned char* key_schedule, unsigned char* inverse_schedule);

extern "C" void AES_ECB_encrypt (
        const unsigned char *in,
        unsigned char *out,
        unsigned long length,
        const unsigned char *KS,
        int nr
);
extern "C" void AES_ECB_decrypt (
        const unsigned char *in,
        unsigned char *out,
        unsigned long length,
        const unsigned char *KS,
        int nr
);
extern "C" void AES_CBC_encrypt (
        const unsigned char *in,
        unsigned char *out,
        unsigned char ivec[16],
        unsigned long length,
        const unsigned char *KS,
        int nr
);
extern "C" void AES_CBC_decrypt (
        const unsigned char *in,
        unsigned char *out,
        unsigned char ivec[16],
        unsigned long length,
        const unsigned char *KS,
        int nr
);
extern "C" void AES_CTR_encrypt(
        const unsigned char *in,
        unsigned char *out,
        unsigned char nonce[8],
        unsigned long long counter,
        unsigned long length,
        const unsigned char *KS,
        int nr
);
void AES_CTR_decrypt(
        const unsigned char *in,
        unsigned char *out,
        unsigned char nonce[8],
        unsigned long long counter,
        unsigned long length,
        const unsigned char *KS,
        int nr
);

// similar to encrypt_file with max_size = 0
void encrypt_file_whole(
        const char* filename,
        unsigned char* key,
        unsigned char nonce[8],
        unsigned long long counter,
        int rounds // either 10, 12 or 14
);

// similar to decrypt_file with max_size = 0
void decrypt_file_whole(
        const char* filename,
        unsigned char* key,
        unsigned char nonce[8],
        unsigned long long counter,
        int rounds // either 10, 12 or 14
);

void encrypt_file(
        const char* filename,
        unsigned char* key,
        unsigned char nonce[8],
        unsigned long long counter,
        int rounds, // either 10, 12 or 14
        unsigned long long max_size = 0
);

void decrypt_file(
        const char* filename,
        unsigned char* key,
        unsigned char nonce[8],
        unsigned long long counter,
        int rounds, // either 10, 12 or 14
        unsigned long long max_size = 0
);

int pad(unsigned char* bytes, unsigned int length);
unsigned int unpad(unsigned char* bytes, unsigned int length);

#endif //AES_ENCRYPTION_ENCRYPTION_H
