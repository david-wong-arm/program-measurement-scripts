#include <stdint.h>

#define KERNEL(name) void name (uint64_t nrep, uint64_t niter, void *s1, void *s2, void *s3) { \
      uint64_t r = nrep, i;                                             \
      uint64_t S2560B;                                                  \
                                                                        \
      __asm__ volatile (                                                \
         "1:\n\t"                                                       \
         "MOV %[niter],%[i]\n\t"                                        \
         "XOR %[S2560B],%[S2560B]\n\t"                                  \
         "2:\n\t"                                                       \
         "VMOVSS 0(%[s1],%[S2560B]),%%xmm0\n\t"                          \
         "VMOVSS 640(%[s1],%[S2560B]),%%xmm1\n\t"                        \
         "VMOVSS 1280(%[s1],%[S2560B]),%%xmm2\n\t"                       \
         "VMOVSS 1920(%[s1],%[S2560B]),%%xmm3\n\t"                       \
         "VMOVSS 0(%[s2],%[S2560B]),%%xmm4\n\t"                          \
         "VMOVSS 640(%[s2],%[S2560B]),%%xmm5\n\t"                        \
         "VMOVSS 1280(%[s2],%[S2560B]),%%xmm6\n\t"                       \
         "VMOVSS 1920(%[s2],%[S2560B]),%%xmm7\n\t"                       \
         "VMOVSS 0(%[s3],%[S2560B]),%%xmm8\n\t"                          \
         "VMOVSS 640(%[s3],%[S2560B]),%%xmm9\n\t"                        \
         "VMOVSS 1280(%[s3],%[S2560B]),%%xmm10\n\t"                      \
         "VMOVSS 1920(%[s3],%[S2560B]),%%xmm11\n\t"                      \
         "ADD $2560,%[S2560B]\n\t"                                      \
         "SUB $1,%[i]\n\t"                                              \
         "JNE 2b\n\t"                                                   \
         "SUB $1,%[r]\n\t"                                              \
         "JNE 1b\n\t"                                                   \
         /* outputs */                                                  \
         : [r] "+r" (r),                                                \
           [i] "=&r" (i),                                               \
           [S2560B] "=&r" (S2560B)                                      \
           /* inputs */                                                 \
         : [niter] "r" (niter),                                         \
           [s1] "r" (s1),                                               \
           [s2] "r" (s2),                                               \
           [s3] "r" (s3)                                                \
           /* clobbers */                                               \
         : "cc", "memory", "xmm0", "xmm1", "xmm2", "xmm3", "xmm4", "xmm5", "xmm6", "xmm7", "xmm8", "xmm9", "xmm10", "xmm11" \
         );                                                             \
   }

KERNEL(kernel_warmup)
KERNEL(kernel_target)
