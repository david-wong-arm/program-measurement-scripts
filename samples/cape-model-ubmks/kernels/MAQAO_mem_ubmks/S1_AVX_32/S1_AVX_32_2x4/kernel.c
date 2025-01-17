#include <stdint.h>

#define KERNEL(name) void name (uint64_t nrep, uint64_t niter, void *s1, void *s2) { \
      uint64_t r = nrep, i;                                             \
      uint64_t S16B;                                                    \
                                                                        \
      __asm__ volatile (                                                \
         "1:\n\t"                                                       \
         "MOV %[niter],%[i]\n\t"                                        \
         "XOR %[S16B],%[S16B]\n\t"                                      \
         "2:\n\t"                                                       \
         "VMOVSS 0(%[s1],%[S16B]),%%xmm0\n\t"                           \
         "VMOVSS 4(%[s1],%[S16B]),%%xmm1\n\t"                           \
         "VMOVSS 8(%[s1],%[S16B]),%%xmm2\n\t"                           \
         "VMOVSS 12(%[s1],%[S16B]),%%xmm3\n\t"                          \
         "VMOVSS 0(%[s2],%[S16B]),%%xmm4\n\t"                           \
         "VMOVSS 4(%[s2],%[S16B]),%%xmm5\n\t"                           \
         "VMOVSS 8(%[s2],%[S16B]),%%xmm6\n\t"                           \
         "VMOVSS 12(%[s2],%[S16B]),%%xmm7\n\t"                          \
         "ADD $16,%[S16B]\n\t"                                          \
         "SUB $1,%[i]\n\t"                                              \
         "JNE 2b\n\t"                                                   \
         "SUB $1,%[r]\n\t"                                              \
         "JNE 1b\n\t"                                                   \
         /* outputs */                                                  \
         : [r] "+r" (r),                                                \
           [i] "=&r" (i),                                               \
           [S16B] "=&r" (S16B)                                          \
           /* inputs */                                                 \
         : [niter] "r" (niter),                                         \
           [s1] "r" (s1),                                               \
           [s2] "r" (s2)                                                \
           /* clobbers */                                               \
         : "cc", "memory", "xmm0", "xmm1", "xmm2", "xmm3", "xmm4", "xmm5", "xmm6", "xmm7" \
         );                                                             \
   }

KERNEL(kernel_target)
KERNEL(kernel_warmup)

