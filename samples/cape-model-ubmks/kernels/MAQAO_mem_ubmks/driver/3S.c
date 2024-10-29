#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include <time.h>

#define PAGE_SIZE (2UL * 1024 * 1024) // 2 MB
#define ALIGNMENT PAGE_SIZE
#define OFFSET_S1 0
#define OFFSET_S2 64
#define OFFSET_S3 128

extern void kernel_target (uint64_t nrep, uint64_t niter, void *s1, void *s2, void *s3);
extern void kernel_warmup (uint64_t nrep, uint64_t niter, void *s1, void *s2, void *s3);

static uint64_t rdtsc (void) {
   uint64_t a, d;
   __asm__ volatile ("rdtsc" : "=a" (a), "=d" (d));
   return (d<<32) | a;
}

int read_arguments (int* nmet, int* nrepw, int* nrepm, int* niter, int* stsz)
{
   FILE* file;

   file = fopen ("codelet.data", "r");

   if (file != NULL)
   {
      int res;

      res = fscanf (file, "%d %d %d %d %d", nmet, nrepw, nrepm, niter, stsz);
      if (res != 5) {
         fclose (file);
         return -1;
      }
      fclose (file);
      return 0;
   }
   return -1;
}

int main (int argc, char *argv[]) {
   int nmet;  // number of meta-repetitions
   int nrepw; // number of kernel repetitions in warmup
   int nrepm; // number of kernel repetitions to measure
   int niter; // number of kernel iterations
   int stsz;  // stream size

   if (read_arguments (&nmet, &nrepw, &nrepm, &niter, &stsz) == -1){
      printf ("Failed to load codelet.data!\n");
      return -1;
   }

   int m;
   const size_t ext_stsz = stsz + 2 * PAGE_SIZE; // Be sure to use 2M hugepages

   // for each meta-repetition
   for (m=0; m<nmet; m++) {
      // streams allocation and first touch
      void *s1_ptr; if(posix_memalign (&s1_ptr, ALIGNMENT, ext_stsz));
      void *s2_ptr; if(posix_memalign (&s2_ptr, ALIGNMENT, ext_stsz));
      void *s3_ptr; if(posix_memalign (&s3_ptr, ALIGNMENT, ext_stsz));
      memset (s1_ptr, 1, ext_stsz); void *s1 = (char *) s1_ptr + OFFSET_S1;
      memset (s2_ptr, 1, ext_stsz); void *s2 = (char *) s2_ptr + OFFSET_S2;
      memset (s3_ptr, 1, ext_stsz); void *s3 = (char *) s3_ptr + OFFSET_S3;

      // warmup
      if (m == 0) {
         // First meta-repetition: cold machine
         clock_t start = clock();
         kernel_warmup (nrepw, niter, s1,s2,s3);
         clock_t stop = clock();
         const float warmup_time = (stop - start) / (1.0f * CLOCKS_PER_SEC); // seconds
         printf ("Warmup: %.2f seconds%s\n", warmup_time,
                 warmup_time < 0.1f ? " (< 100 ms: increase repw)":"");
      } else {
         // Machine already at full speed, just retrain caches and HW prefetchers
         kernel_warmup (1, niter, s1,s2,s3);
      }

      // measure
      measure_init_();
      measure_start_();
      kernel_target (nrepm, niter, s1,s2,s3);
      measure_stop_();

      // streams release
      free (s1_ptr);
      free (s2_ptr);
      free (s3_ptr);
   }

   return 0;
}
