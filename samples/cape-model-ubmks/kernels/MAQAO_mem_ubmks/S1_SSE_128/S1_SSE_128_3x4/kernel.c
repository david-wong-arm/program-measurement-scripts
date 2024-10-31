#include <stdint.h>

#define KERNEL(name) void name (uint64_t nrep, uint64_t niter, void *s1, void *s2, void *s3) { \
      uint64_t r = nrep, i;                                             \
      uint64_t S64B;                                                   \
                                                                        \
      __asm__ volatile (                                                \
         "1:\n\t"                                                       \
         "MOV %[niter],%[i]\n\t"                                        \
         "XOR %[S64B],%[S64B]\n\t"                                    \
         "2:\n\t"                                                       \
         "MOVUPS 0(%[s1],%[S64B]),%%xmm0\n\t"                         \
         "MOVUPS 16(%[s1],%[S64B]),%%xmm1\n\t"                        \
         "MOVUPS 32(%[s1],%[S64B]),%%xmm2\n\t"                        \
         "MOVUPS 48(%[s1],%[S64B]),%%xmm3\n\t"                        \
         "MOVUPS 0(%[s2],%[S64B]),%%xmm4\n\t"                         \
         "MOVUPS 16(%[s2],%[S64B]),%%xmm5\n\t"                        \
         "MOVUPS 32(%[s2],%[S64B]),%%xmm6\n\t"                        \
         "MOVUPS 48(%[s2],%[S64B]),%%xmm7\n\t"                        \
         "MOVUPS 0(%[s3],%[S64B]),%%xmm8\n\t"                         \
         "MOVUPS 16(%[s3],%[S64B]),%%xmm9\n\t"                        \
         "MOVUPS 32(%[s3],%[S64B]),%%xmm10\n\t"                       \
         "MOVUPS 48(%[s3],%[S64B]),%%xmm11\n\t"                       \
         "ADD $64,%[S64B]\n\t"                                         \
         "SUB $1,%[i]\n\t"                                              \
         "JNE 2b\n\t"                                                   \
         "SUB $1,%[r]\n\t"                                              \
         "JNE 1b\n\t"                                                   \
         /* outputs */                                                  \
         : [r] "+r" (r),                                                \
           [i] "=&r" (i),                                               \
           [S64B] "=&r" (S64B)                                        \
           /* inputs */                                                 \
         : [niter] "r" (niter),                                         \
           [s1] "r" (s1),                                               \
           [s2] "r" (s2),                                               \
           [s3] "r" (s3)                                                \
           /* clobbers */                                               \
         : "cc", "memory", "xmm0", "xmm1", "xmm2", "xmm3", "xmm4", "xmm5", "xmm6", "xmm7", "xmm8", "xmm9", "xmm10", "xmm11" \
         );                                                             \
   }

KERNEL(kernel_target)
KERNEL(kernel_warmup)
