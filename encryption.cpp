#include "encryption.h"


// padding scheme PKCS#7
int pad(unsigned char* bytes, unsigned int length) {
    unsigned char padding = 16 - length % 16;
    for (unsigned int i = length; i < length + padding; ++i) {
        bytes[i] = padding;
    }

    return length + padding;
}

unsigned int unpad(unsigned char* bytes, unsigned int length) {
    return length - bytes[length - 1];
}

void AES_CTR_decrypt(
        const unsigned char *in,
        unsigned char *out,
        unsigned char nonce[8],
        unsigned long long counter,
        unsigned long length,
        const unsigned char *KS,
        int nr) {
    AES_CTR_encrypt(in, out, nonce, counter, length, KS, nr);
}

void encrypt_file_whole(
        const char* filename,
        unsigned char* key,
        unsigned char nonce[8],
        unsigned long long counter,
        int rounds) {

    // open file
    FILE* file = fopen(filename, "rb");
    if (file == NULL) {
        printf("Failed to open file");
        exit(EXIT_FAILURE);
    }

    // obtain file size:
    fseek (file , 0 , SEEK_END);
    unsigned long file_size = ftell (file);
    rewind (file);

    // allocate memory for the buffer
    size_t memory_needed = file_size + 16 - file_size % 16;
    unsigned char* buffer = (unsigned char*) malloc (sizeof(char)*(memory_needed));
    unsigned char* encrypted = (unsigned char*) malloc (sizeof(char)*(memory_needed));
    if (buffer == NULL || encrypted == NULL) {
        printf("Failed to allocate memory for the file");
        exit(EXIT_FAILURE);
    }

    // read the file
    size_t result = fread((void*)buffer, 1, file_size, file);
    if (result != file_size) {
        printf("Reading error");
        exit(EXIT_FAILURE);
    }

    // reopen the file to write to it
    file = freopen(filename, "wb", file);
    if (file == NULL) {
        printf("Failed to reopen the file");
        exit(EXIT_FAILURE);
    }

    // pad the file
    int plaintext_size = pad(buffer, file_size);

    // key schedule
    unsigned char* KS;
    if (rounds < 12) {
        KS = (unsigned char*)malloc(sizeof(unsigned char) * 176);
        AES_128_Key_Expansion(key, KS);
    } else if (rounds < 14) {
        KS = (unsigned char*)malloc(sizeof(unsigned char) * 208);
        AES_192_Key_Expansion(key, KS);
    } else {
        KS = (unsigned char*)malloc(sizeof(unsigned char) * 240);
        AES_256_Key_Expansion(key, KS);
    }

    // encrypt the file
    AES_CTR_encrypt(buffer, encrypted, nonce, counter, (unsigned long)plaintext_size, KS, rounds);
    int written = fwrite(encrypted, 1, plaintext_size, file);
    if (written != plaintext_size) {
        printf("Failed to write file");
        exit(EXIT_FAILURE);
    }

    // free memory
    free(buffer);
    free(encrypted);
    fclose(file);
}

void decrypt_file_whole(
        const char* filename,
        unsigned char* key,
        unsigned char nonce[8],
        unsigned long long counter,
        int rounds
) {
    // open file
    FILE* file = fopen(filename, "rb");
    if (file == NULL) {
        printf("Failed to open file");
        exit(EXIT_FAILURE);
    }

    // obtain file size:
    fseek (file , 0 , SEEK_END);
    unsigned long file_size = ftell (file);
    rewind (file);

    if (file_size % 16 != 0) {
        printf("File size is not a multiple of 16");
        exit(EXIT_FAILURE);
    }

    // allocate memory for the buffer
    size_t memory_needed = file_size;
    unsigned char* buffer = (unsigned char*) malloc (sizeof(char)*(memory_needed));
    unsigned char* decrypted = (unsigned char*) malloc (sizeof(char)*(memory_needed));
    if (buffer == NULL || decrypted == NULL) {
        printf("Failed to allocate memory for the file");
        exit(EXIT_FAILURE);
    }

    // read the file
    size_t result = fread((void*)buffer, 1, file_size, file);
    if (result != file_size) {
        printf("Reading error");
        exit(EXIT_FAILURE);
    }

    // reopen the file to write to it
    file = freopen(filename, "wb", file);
    if (file == NULL) {
        printf("Failed to reopen the file");
        exit(EXIT_FAILURE);
    }

    // do the key expansion
    unsigned char* KS;
    if (rounds < 12) {
        KS = (unsigned char*)malloc(sizeof(unsigned char) * 176);
        AES_128_Key_Expansion(key, KS);
    } else if (rounds < 14) {
        KS = (unsigned char*)malloc(sizeof(unsigned char) * 208);
        AES_192_Key_Expansion(key, KS);
    } else {
        KS = (unsigned char*)malloc(sizeof(unsigned char) * 240);
        AES_256_Key_Expansion(key, KS);
    }

    // decrypt the file
    AES_CTR_decrypt(buffer, decrypted, nonce, counter, (unsigned long)file_size, KS, rounds);
    int plaintext_size = unpad(decrypted, file_size);
    int written = fwrite(decrypted, 1, plaintext_size, file);
    if (written != plaintext_size) {
        printf("Failed to write file");
        exit(EXIT_FAILURE);
    }

    // free some memory
    free(buffer);
    free(decrypted);
    fclose(file);
}

void encrypt_file (
        const char* filename,
        unsigned char* key,
        unsigned char nonce[8],
        unsigned long long counter,
        int rounds,
        int max_size) {

    // open file
    FILE* file = fopen(filename, "r+b");
    if (file == NULL) {
        printf("Failed to open file");
        exit(EXIT_FAILURE);
    }

    // obtain file size:
    fseek (file , 0 , SEEK_END);
    unsigned long file_size = ftell (file);
    rewind (file);

    // allocate memory for the buffers
    size_t memory_needed;
    if (max_size < 16) {
        memory_needed = file_size + 16 - file_size % 16;
        max_size = file_size;
    } else {
        max_size = max_size/16*16;
        memory_needed = max_size + 16; // reserve some for padding
    }
    unsigned char* buffer = (unsigned char*) malloc (sizeof(char)*(memory_needed));
    unsigned char* encrypted = (unsigned char*) malloc (sizeof(char)*(memory_needed));
    if (buffer == NULL || encrypted == NULL) {
        printf("Failed to allocate memory for the file");
        exit(EXIT_FAILURE);
    }

    // key schedule
    unsigned char *KS;
    if (rounds < 12) {
        KS = (unsigned char *) malloc(sizeof(unsigned char) * 176);
        AES_128_Key_Expansion(key, KS);
    } else if (rounds < 14) {
        KS = (unsigned char *) malloc(sizeof(unsigned char) * 208);
        AES_192_Key_Expansion(key, KS);
    } else {
        KS = (unsigned char *) malloc(sizeof(unsigned char) * 240);
        AES_256_Key_Expansion(key, KS);
    }

    unsigned long long total_read = 0;
    size_t plaintext_size = max_size;
    do {
        // read from the file
        size_t read = fread((void *) buffer, 1, max_size, file);
        total_read += read;
        if (read != max_size && !feof(file)) {
            printf("Reading error");
            exit(EXIT_FAILURE);
        }

        // pad if it's the last block read
        if (total_read == file_size) {
            plaintext_size = pad(buffer, read);
        }

        // seek the file to where it was before reading in order to be able to write the encrypted data
        fseek(file, -read, SEEK_CUR);

        // encrypt the file
        AES_CTR_encrypt(buffer, encrypted, nonce, counter + (total_read - read) / 16, (unsigned long) plaintext_size, KS, rounds);
        int written = fwrite(encrypted, 1, plaintext_size, file);
        if (written != plaintext_size) {
            printf("Failed to write file");
            exit(EXIT_FAILURE);
        }
    } while (total_read < file_size);

    // free memory
    free(buffer);
    free(encrypted);
    fclose(file);
}

void decrypt_file (
        const char* filename,
        unsigned char* key,
        unsigned char nonce[8],
        unsigned long long counter,
        int rounds,
        int max_size) {

    // open file
    FILE* file = fopen(filename, "r+b");
    if (file == NULL) {
        printf("Failed to open file");
        exit(EXIT_FAILURE);
    }

    // obtain file size:
    fseek (file , 0 , SEEK_END);
    unsigned long file_size = ftell (file);
    rewind (file);

    if (file_size % 16 != 0) {
        printf("File size is not a multiple of 16");
        exit(EXIT_FAILURE);
    }

    // allocate memory for the buffers
    size_t memory_needed;
    if (max_size < 16) {
        memory_needed = file_size;
        max_size = file_size;
    } else {
        max_size = max_size/16*16;
        memory_needed = max_size;
    }
    unsigned char* buffer = (unsigned char*) malloc (sizeof(char) * (memory_needed));
    unsigned char* decrypted = (unsigned char*) malloc (sizeof(char) * (memory_needed));
    if (buffer == NULL || decrypted == NULL) {
        printf("Failed to allocate memory for the file");
        exit(EXIT_FAILURE);
    }

    // key schedule
    unsigned char *KS;
    if (rounds < 12) {
        KS = (unsigned char *) malloc(sizeof(unsigned char) * 176);
        AES_128_Key_Expansion(key, KS);
    } else if (rounds < 14) {
        KS = (unsigned char *) malloc(sizeof(unsigned char) * 208);
        AES_192_Key_Expansion(key, KS);
    } else {
        KS = (unsigned char *) malloc(sizeof(unsigned char) * 240);
        AES_256_Key_Expansion(key, KS);
    }

    unsigned long long total_read = 0;
    size_t cyphertext_size = max_size;
    unsigned long padding = 0;
    do {
        // read from the file
        size_t read = fread((void *) buffer, 1, max_size, file);
        total_read += read;
        if (read != max_size && !feof(file)) {
            printf("Reading error");
            exit(EXIT_FAILURE);
        }

        // decrypt the file
        AES_CTR_decrypt(buffer, decrypted, nonce, counter + (total_read - read) / 16, (unsigned long) read, KS, rounds);
        // unpad if we reached the last block
        if (total_read == file_size) {
            cyphertext_size = unpad(decrypted, read);
            padding = read - cyphertext_size;
        }
        // seek the file to where it was before reading in order to be able to write the decrypted data
        fseek(file, -read, SEEK_CUR);
        // write to the file
        int written = fwrite(decrypted, 1, cyphertext_size, file);
        if (written != cyphertext_size) {
            printf("Failed to write file");
            exit(EXIT_FAILURE);
        }
    } while (total_read < file_size);

    // free memory
    free(buffer);
    free(decrypted);
    fclose(file);

    // truncate the file to remove the extra characters in the file
    truncate(filename, file_size - padding);
}
