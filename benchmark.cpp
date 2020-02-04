#include "benchmark.h"

unsigned long long get_time(){
    return std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
}

void generate_bytes(size_t size, unsigned char* bytes) {
    srand(get_time());

    for (int i = 0; i < size; ++i) {
        bytes[i] = rand() % 256;
    }
}

unsigned long long benchmark(size_t size, unsigned long times, bool from_file) {
    srand(get_time());

    unsigned char* bytes = (unsigned char*)malloc(size);
    unsigned char* out;
    if (!from_file) out = (unsigned char*)malloc(size);
    generate_bytes(size, bytes);

    if (from_file) {
        FILE *file = fopen("testfile", "wb");
        fwrite(bytes, 1, size, file);
        fclose(file);
    }

    unsigned char nonce[8];
    unsigned char key[32];
    unsigned long long total_time = 0;
    for (int i = 0; i < times; ++i) {
        unsigned long long counter = rand();
        for (int j = 0; j < 8; ++j) {
            nonce[j] = rand() % 256;
        }
        for (int j = 0; j < 32; ++j) {
            key[j] = rand() % 256;
        }
        unsigned long long curr_time = get_time();
        if (from_file) {
            encrypt_file("testfile", key, nonce, counter, 14, 100 * 1000);
        } else {
            AES_CTR_encrypt(bytes, out, (unsigned char *) nonce, counter, size, (unsigned char *) key, 14);
        }
        total_time += get_time() - curr_time;
    }

    free(bytes);
    if (!from_file) free(bytes);
    return total_time;
}
