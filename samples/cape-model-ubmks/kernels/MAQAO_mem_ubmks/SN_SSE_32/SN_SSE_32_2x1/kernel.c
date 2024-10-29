#include <stdint.h>

#define KERNEL(name) void name (uint64_t nrep, uint64_t niter, void *s1, void *s2) { \
      uint64_t r = nrep, i;                                             \
      uint64_t S640B;                                                   \
                                                                        \
      __asm__ volatile (                                                \
         "1:\n\t"                                                       \
         "MOV %[niter],%[i]\n\t"                                        \
         "XOR %[S640B],%[S640B]\n\t"                                    \
         "2:\n\t"                                                       \
         "MOVSS 0(%[s1],%[S640B]),%%xmm0\n\t"                           \
         "MOVSS 0(%[s2],%[S640B]),%%xmm1\n\t"                           \
         "ADD $640,%[S640B]\n\t"                                        \
         "SUB $1,%[i]\n\t"                                              \
         "JNE 2b\n\t"                                                   \
         "SUB $1,%[r]\n\t"                                              \
         "JNE 1b\n\t"                                                   \
         /* outputs */                                                  \
         : [r] "+r" (r),                                                \
           [i] "=&r" (i),                                               \
           [S640B] "=&r" (S640B)                                        \
           /* inputs */                                                 \
         : [niter] "r" (niter),                                         \
           [s1] "r" (s1),                                               \
           [s2] "r" (s2)                                                \
           /* clobbers */                                               \
         : "cc", "memory", "xmm0", "xmm1"                               \
         );                                                             \
   }

KERNEL(kernel_warmup)
KERNEL(kernel_target)
