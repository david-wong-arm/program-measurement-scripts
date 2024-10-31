#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "rdtsc.h"
#include "util.h"

#define LINE_SIZE 64
#define NUM_STREAMS 3

unsigned int scale_ (int, struct item*, int, struct item*, struct item*); // Using David Wong's 'in codelet' repetitions



void dumpMemList(char* alignedMem, int nb_elements) {
  struct item* start = (struct item*)alignedMem;
  int i;
  printf("nb_elements = %d\n", nb_elements);
  for (i = 0; i<nb_elements; i++) {
    struct item* next = start[i].next;
    printf("%d (%p) -> ", i, &start[i]);
    if (next == NULL) 
      printf("NULL\n");
    else
      printf("%d\n", (int)(next - start));
  }
}

int main (int argc, char** argv)
{
	unsigned int align = 64;
	unsigned long long int before, after;
	unsigned long long nb_elements, repetitions, inner_rep, nb_elements_per_list;
        int shuffle;

	void* mem;
	char* mem1;
	char* mem2;
	char* alignedMem;
	char* alignedMem1;
	char* alignedMem2;
	float* tab;

	unsigned int nb_iters;


	//	int n;

        srand(8088);

	if (read_arguments (&nb_elements, &inner_rep, &repetitions, &shuffle) == -1){
		printf ("Failed to load codelet.data!\n");
		return -1;
	}
	nb_elements_per_list = nb_elements/NUM_STREAMS;

	printf ("Nb elements: %llu.\n", nb_elements);
	printf ("Nb elements per list: %llu.\n", nb_elements_per_list);
	printf ("Nb repetitions: %llu.\n", repetitions);


	//        int streamSize = sizeof(struct item) * nb_elements_per_list;
        int streamSize = sizeof(struct item) * nb_elements;
	int alignedSize = alignUp(streamSize, align);
	printf ("AlignedSize: %d.\n", alignedSize);
	printf ("align: %d.\n", align);

	//mem = malloc (sizeof (float) * (nb_elements*5) + 4096);
	//	mem = malloc (3*(alignedSize + align));
//	mem = malloc (alignedSize);
	int alloc_status=posix_memalign(&mem, align, alignedSize);
	assert (alloc_status == 0);
	printf ("mem: %p.\n", mem);
	alignedMem = initAlignMem(mem, align, alignedSize);

#if 0
	alignedMem1 = alignedMem+64;
	alignedMem2 = alignedMem+128;

	//		mem = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
		mem1 = mem + (alignedSize + align);
	//	mem1 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	//	mem2 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
		mem2 = mem1 + (alignedSize + align);
		//	mem1 = mem;
		//		mem2 = mem;

	assert(((unsigned long long )alignedMem) % align == 0);		
	assert(((unsigned long long) alignedMem1) % align == 0);
	assert(((unsigned long long) alignedMem2) % align == 0);
	makeList(alignedMem, nb_elements_per_list,3, nb_elements);
	makeList(alignedMem1, nb_elements_per_list,3, nb_elements);
	makeList(alignedMem2, nb_elements_per_list,3, nb_elements);
#else
	alignedMem1 = alignedMem+64*nb_elements_per_list;
	alignedMem2 = alignedMem+128*nb_elements_per_list;
	assert(((unsigned long long )alignedMem) % align == 0);		
	assert(((unsigned long long) alignedMem1) % align == 0);
	assert(((unsigned long long) alignedMem2) % align == 0);
	makeStridedList(alignedMem, nb_elements_per_list,1, nb_elements, shuffle);
	makeStridedList(alignedMem1, nb_elements_per_list,1, nb_elements, shuffle);
	makeStridedList(alignedMem2, nb_elements_per_list,1, nb_elements, shuffle);
	
#endif


	//dumpMemList (alignedMem, nb_elements);

	/*
	alignedMem = makeListAligned(mem, align, alignedSize, nb_elements_per_list, shuffle);
	alignedMem1 = makeListAligned(mem1, align, alignedSize, nb_elements_per_list, shuffle);
	alignedMem2 = makeListAligned(mem2, align, alignedSize, nb_elements_per_list, shuffle);
	*/


//	rdtscll (before);

	measure_init_();
	measure_start_();
	//	nb_iters = scale_ (n, (float*)(alignedMem), (float*)(alignedMem+alignedSize), (float*)(alignedMem+2*alignedSize), 
	//		(float*)(alignedMem+3*alignedSize), (float*)(alignedMem+4*alignedSize), repetitions);
	nb_iters = scale_ (inner_rep, (struct item*)(alignedMem), repetitions, (struct item*)(alignedMem1), (struct item*)(alignedMem2));
	measure_stop_();

//	rdtscll (after);
//	cnt = (struct item*)alignedMem;
	// printf("last data = %d\n", cnt[n-1].data);

	printf ("Nb iters0: %u.\n", nb_iters);
	nb_iters /= repetitions;
	printf ("Nb iters1: %u.\n", nb_iters);
	nb_iters = nb_elements / 8;
	nb_iters = nb_iters/2;  // number of streams.  Just to be consistent with original pointer tracing.
	printf ("Nb iters: %u.\n", nb_iters);
	printf ("RDTSC: %lf.\n", ((double)(after - before)) / (double)repetitions / (double)nb_iters );

	free (mem);
	//	free (mem1);

	return 0;

}
