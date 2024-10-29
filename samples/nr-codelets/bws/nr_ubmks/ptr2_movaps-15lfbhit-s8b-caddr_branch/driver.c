#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "rdtsc.h"

#define LINE_SIZE 64
#define NUM_STREAMS 2

struct item {
  struct item *next;
  int data;
  char padding[LINE_SIZE-sizeof(struct item*)-sizeof(int)];
};

unsigned int scale_ (int, struct item*, int, struct item*); // Using David Wong's 'in codelet' repetitions

int read_arguments (int* nb_elements, int* inner_rep ,int* repetitions)
{
	FILE* file;

	file = fopen ("codelet.data", "r");

	if (file != NULL)
	{
		int res;

		res = fscanf (file, "%d %d", repetitions, inner_rep);
		if (res != 2)
		{
			fclose (file);
			return -1;
		}
//		(*nb_elements) = 26;  // hardcoded to be 26
		(*nb_elements) = (*inner_rep);  
		if ((*inner_rep) < 1000) {
			(*inner_rep) = 1000;
		}

		fclose (file);

		return 0;
	}
	return -1;
}

unsigned long long alignUp(unsigned long long original, unsigned int align) {
	return (original +align - (original % align));
}

void makeList(char* alignedMem, int nb_elements, int stride, int n) {
	int i;


	//tab = (float*)(mem - (unsigned long long) mem % 32);
	//tab = tab + 8;  // 8 SP = 32 bytes

	//	int n = nb_elements;
	struct item* cnt = (struct item*)alignedMem;
	struct item* start = (struct item*)alignedMem;
	for (i=0; i<nb_elements-1; i++) {
	  start[(i*stride)%n].next = &start[((i+1)*stride) % n];
	  //	  cnt->next = cnt+1;
          /*
	  if (i>n-10) {
	    printf("%p, %ld\n", cnt, ((char*)cnt-alignedMem));
	  }
	  */
	  //	  cnt = cnt->next;
	}
	cnt = &start[((nb_elements-1)*stride)%n];
	printf("Done @ %p\n", cnt);
	cnt->next = (struct item*)alignedMem; // make it circular.  Need this dispite of the % in loop
	// printf("after write\n");
	cnt = (struct item*)alignedMem;
	// printf("last data = %d\n", cnt[n-1].data);
}

char* initAlignMem(char* mem, int align, int alignedSize) {
  // printf("alloc-->%p - %p, size=%d\n", mem, (mem+alignedSize+align), alignedSize+align);
  char * alignedMem = (char*) alignUp((unsigned long long)mem, align);
  //memset (tab, 0, n * sizeof(double));
  
  memset (alignedMem, 0, alignedSize);
}

char* makeListAligned(char* mem, int align, int alignedSize, int nb_elements, int stride) {
  char* alignedMem;
  int i;
  if (mem == NULL)
    {
      printf ("Could not allocate the main array.\n");
      return 0;
    }
  
  alignedMem = initAlignMem(mem, align, alignedSize);
  makeList(alignedMem, nb_elements, stride, nb_elements);
  return alignedMem;
}

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
	int nb_elements, repetitions, inner_rep, nb_elements_per_list;

	char* mem;
	char* mem1;
	char* mem2;
	char* alignedMem;
	char* alignedMem1;
	float* tab;

	unsigned int nb_iters;


	//	int n;

	if (read_arguments (&nb_elements, &inner_rep, &repetitions) == -1){
		printf ("Failed to load codelet.data!\n");
		return -1;
	}
	nb_elements_per_list = nb_elements/NUM_STREAMS;

	printf ("Nb elements: %d.\n", nb_elements);
	printf ("Nb elements per list: %d.\n", nb_elements_per_list);
	printf ("Nb repetitions: %d.\n", repetitions);


	//        int streamSize = sizeof(struct item) * nb_elements_per_list;
        int streamSize = sizeof(struct item) * nb_elements;
	int alignedSize = alignUp(streamSize, align);
	printf ("AlignedSize: %d.\n", alignedSize);
	printf ("align: %d.\n", align);

	//mem = malloc (sizeof (float) * (nb_elements*5) + 4096);
	//	mem = malloc (3*(alignedSize + align));
	mem = malloc (alignedSize);
	printf ("mem: %p.\n", mem);
	alignedMem = initAlignMem(mem, align, alignedSize);

#if 0
	alignedMem1 = alignedMem+64;

	//		mem = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
		mem1 = mem + (alignedSize + align);
	//	mem1 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	//	mem2 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
		mem2 = mem1 + (alignedSize + align);
		//	mem1 = mem;
		//		mem2 = mem;

	assert(((unsigned long long )alignedMem) % align == 0);		
	assert(((unsigned long long) alignedMem1) % align == 0);
	makeList(alignedMem, nb_elements_per_list,2, nb_elements);
	makeList(alignedMem1, nb_elements_per_list,2, nb_elements);
#else
	alignedMem1 = alignedMem+64*nb_elements_per_list;
	assert(((unsigned long long )alignedMem) % align == 0);		
	assert(((unsigned long long) alignedMem1) % align == 0);
	makeList(alignedMem, nb_elements_per_list,1, nb_elements);
	makeList(alignedMem1, nb_elements_per_list,1, nb_elements);
	
#endif


//	dumpMemList (alignedMem, nb_elements);

	/*
	alignedMem = makeListAligned(mem, align, alignedSize, nb_elements_per_list);
	alignedMem1 = makeListAligned(mem1, align, alignedSize, nb_elements_per_list);
	*/


//	rdtscll (before);

	measure_init_();
	measure_start_();
	//	nb_iters = scale_ (n, (float*)(alignedMem), (float*)(alignedMem+alignedSize), (float*)(alignedMem+2*alignedSize), 
	//		(float*)(alignedMem+3*alignedSize), (float*)(alignedMem+4*alignedSize), repetitions);
	nb_iters = scale_ (inner_rep, (struct item*)(alignedMem), repetitions, (struct item*)(alignedMem1));
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
