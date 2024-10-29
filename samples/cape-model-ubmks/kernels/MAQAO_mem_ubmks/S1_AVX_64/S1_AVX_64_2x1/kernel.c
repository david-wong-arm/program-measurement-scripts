#include <stdint.h>

#define KERNEL(name) void name (uint64_t nrep, uint64_t niter, void *s1, void *s2) { \
      uint64_t r = nrep, i;                                             \
      uint64_t S8B;                                                     \
                                                                        \
      __asm__ volatile (                                                \
         "1:\n\t"                                                       \
         "MOV %[niter],%[i]\n\t"                                        \
         "XOR %[S8B],%[S8B]\n\t"                                        \
         "2:\n\t"                                                       \
         "VMOVSD 0(%[s1],%[S8B]),%%xmm0\n\t"                            \
         "VMOVSD 0(%[s2],%[S8B]),%%xmm1\n\t"                            \
         "ADD $8,%[S8B]\n\t"                                            \
         "SUB $1,%[i]\n\t"                                              \
         "JNE 2b\n\t"                                                   \
         "SUB $1,%[r]\n\t"                                              \
         "JNE 1b\n\t"                                                   \
         /* outputs */                                                  \
         : [r] "+r" (r),                                                \
           [i] "=&r" (i),                                               \
           [S8B] "=&r" (S8B)                                            \
           /* inputs */                                                 \
         : [niter] "r" (niter),                                         \
           [s1] "r" (s1),                                               \
           [s2] "r" (s2)                                                \
           /* clobbers */                                               \
         : "cc", "memory", "xmm0", "xmm1"                               \
         );                                                             \
   }

KERNEL(kernel_target)
KERNEL(kernel_warmup)
