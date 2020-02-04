#ifndef AES_ENCRYPTION_BENCHMARK_H
#define AES_ENCRYPTION_BENCHMARK_H

#include <chrono>
#include <cstdlib>
#include "encryption.h"

unsigned long long get_time();

unsigned long long benchmark(size_t size, unsigned long times, bool from_file=false);
void generate_bytes(size_t size, unsigned char* bytes);

#endif //AES_ENCRYPTION_BENCHMARK_H
