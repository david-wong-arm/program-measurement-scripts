#include <stdint.h>

#define KERNEL(name) void name (uint64_t nrep, uint64_t niter, void *s1) { \
      uint64_t r = nrep, i;                                             \
      uint64_t S32B;                                                    \
                                                                        \
      __asm__ volatile (                                                \
         "1:\n\t"                                                       \
         "MOV %[niter],%[i]\n\t"                                        \
         "XOR %[S32B],%[S32B]\n\t"                                      \
         "2:\n\t"                                                       \
         "VMOVUPS 0(%[s1],%[S32B]),%%ymm0\n\t"                          \
         "ADD $32,%[S32B]\n\t"                                          \
         "SUB $1,%[i]\n\t"                                              \
         "JNE 2b\n\t"                                                   \
         "SUB $1,%[r]\n\t"                                              \
         "JNE 1b\n\t"                                                   \
         /* outputs */                                                  \
         : [r] "+r" (r),                                                \
           [i] "=&r" (i),                                               \
           [S32B] "=&r" (S32B)                                          \
           /* inputs */                                                 \
         : [niter] "r" (niter),                                         \
           [s1] "r" (s1)                                                \
           /* clobbers */                                               \
         : "cc", "memory", "xmm0"                                       \
         );                                                             \
   }

KERNEL(kernel_target)
KERNEL(kernel_warmup)
