#include <stdint.h>

#define KERNEL(name) void name (uint64_t nrep, uint64_t niter, void *s1) { \
      uint64_t r = nrep, i;                                             \
      uint64_t S1280B;                                                  \
                                                                        \
      __asm__ volatile (                                                \
         "1:\n\t"                                                       \
         "MOV %[niter],%[i]\n\t"                                        \
         "XOR %[S1280B],%[S1280B]\n\t"                                  \
         "2:\n\t"                                                       \
         "MOVSD 0(%[s1],%[S1280B]),%%xmm0\n\t"                          \
         "MOVSD 640(%[s1],%[S1280B]),%%xmm1\n\t"                        \
         "ADD $1280,%[S1280B]\n\t"                                      \
         "SUB $1,%[i]\n\t"                                              \
         "JNE 2b\n\t"                                                   \
         "SUB $1,%[r]\n\t"                                              \
         "JNE 1b\n\t"                                                   \
         /* outputs */                                                  \
         : [r] "+r" (r),                                                \
           [i] "=&r" (i),                                               \
           [S1280B] "=&r" (S1280B)                                      \
           /* inputs */                                                 \
         : [niter] "r" (niter),                                         \
           [s1] "r" (s1)                                                \
           /* clobbers */                                               \
         : "cc", "memory", "xmm0", "xmm1"                               \
         );                                                             \
   }

KERNEL(kernel_target)
KERNEL(kernel_warmup)
