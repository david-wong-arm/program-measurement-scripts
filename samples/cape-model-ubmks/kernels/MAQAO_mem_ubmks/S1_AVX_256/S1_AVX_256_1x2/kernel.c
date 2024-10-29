#include <stdint.h>

#define KERNEL(name) void name (uint64_t nrep, uint64_t niter, void *s1) { \
      uint64_t r = nrep, i;                                             \
      uint64_t S64B;                                                    \
                                                                        \
      __asm__ volatile (                                                \
         "1:\n\t"                                                       \
         "MOV %[niter],%[i]\n\t"                                        \
         "XOR %[S64B],%[S64B]\n\t"                                      \
         "2:\n\t"                                                       \
         "VMOVUPS 0(%[s1],%[S64B]),%%ymm0\n\t"                          \
         "VMOVUPS 32(%[s1],%[S64B]),%%ymm1\n\t"                         \
         "ADD $64,%[S64B]\n\t"                                          \
         "SUB $1,%[i]\n\t"                                              \
         "JNE 2b\n\t"                                                   \
         "SUB $1,%[r]\n\t"                                              \
         "JNE 1b\n\t"                                                   \
         /* outputs */                                                  \
         : [r] "+r" (r),                                                \
           [i] "=&r" (i),                                               \
           [S64B] "=&r" (S64B)                                          \
           /* inputs */                                                 \
         : [niter] "r" (niter),                                         \
           [s1] "r" (s1)                                                \
           /* clobbers */                                               \
         : "cc", "memory", "xmm0", "xmm1"                               \
         );                                                             \
   }

KERNEL(kernel_target)
KERNEL(kernel_warmup)
