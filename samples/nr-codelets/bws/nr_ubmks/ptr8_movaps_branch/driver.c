#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "rdtsc.h"

#define LINE_SIZE 64
#define NUM_STREAMS 8

struct item {
  struct item *next;
  int data;
  char padding[LINE_SIZE-sizeof(struct item*)-sizeof(int)];
};

extern struct item* glo_p5;
extern struct item* glo_p6;
extern struct item* glo_p7;
extern struct item* glo_p8;

unsigned int scale_ (int, struct item*, int, struct item*, struct item*, struct item*); // Using David Wong's 'in codelet' repetitions

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

char* makeList(char* mem, int align, int alignedSize, int nb_elements) {
	char* alignedMem;
	int i;

  // printf("alloc-->%p - %p, size=%d\n", mem, (mem+alignedSize+align), alignedSize+align);
  if (mem == NULL)
	{
	  printf ("Could not allocate the main array.\n");
	  return 0;
	}
	alignedMem = (char*) alignUp((unsigned long long)mem, align);

	//tab = (float*)(mem - (unsigned long long) mem % 32);
	//tab = tab + 8;  // 8 SP = 32 bytes

	int n = nb_elements;
	//memset (tab, 0, n * sizeof(double));

	memset (alignedMem, 0, alignedSize);
	struct item* cnt = (struct item*)alignedMem;
	for (i=0; i<n-1; i++) {
	  cnt->next = cnt+1;
          /*
	  if (i>n-10) {
	    printf("%p, %ld\n", cnt, ((char*)cnt-alignedMem));
	  }
	  */
	  cnt = cnt->next;
	}
	// printf("Done @ %p\n", cnt);
	cnt->next = (struct item*)alignedMem; // make it circular
	// printf("after write\n");
	cnt = (struct item*)alignedMem;
	// printf("last data = %d\n", cnt[n-1].data);

// REDO TO CHECK init o/h
	memset (alignedMem, 0, alignedSize);
	cnt = (struct item*)alignedMem;
	for (i=0; i<n-1; i++) {
	  cnt->next = cnt+1;
          /*
	  if (i>n-10) {
	    printf("%p, %ld\n", cnt, ((char*)cnt-alignedMem));
	  }
	  */
	  cnt = cnt->next;
	}
	// printf("Done @ %p\n", cnt);
	cnt->next = (struct item*)alignedMem; // make it circular
	// printf("after write\n");
	cnt = (struct item*)alignedMem;
	// printf("last data = %d\n", cnt[n-1].data);
// REDO TO CHECK init o/h

}

int main (int argc, char** argv)
{
	unsigned int align = 64;
	unsigned long long int before, after;
	int nb_elements, repetitions, inner_rep, nb_elements_per_list;

	char* mem;
	char* mem1;
	char* mem2;
	char* mem3;
	char* mem4;
	char* mem5;
	char* mem6;
	char* mem7;
	char* alignedMem;
	char* alignedMem1;
	char* alignedMem2;
	char* alignedMem3;
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


        int streamSize = sizeof(struct item) * nb_elements_per_list;
	int alignedSize = alignUp(streamSize, align);
	printf ("AlignedSize: %d.\n", alignedSize);

	//mem = malloc (sizeof (float) * (nb_elements*5) + 4096);
	mem = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem1 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem2 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem3 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem4 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem5 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem6 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem7 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment


	alignedMem = makeList(mem, align, alignedSize, nb_elements_per_list);
	alignedMem1 = makeList(mem1, align, alignedSize, nb_elements_per_list);
	alignedMem2 = makeList(mem2, align, alignedSize, nb_elements_per_list);
	alignedMem3 = makeList(mem3, align, alignedSize, nb_elements_per_list);
	glo_p5 = (struct item*) makeList(mem4, align, alignedSize, nb_elements_per_list);
	glo_p6 = (struct item*) makeList(mem5, align, alignedSize, nb_elements_per_list);
	glo_p7 = (struct item*) makeList(mem6, align, alignedSize, nb_elements_per_list);
	glo_p8 = (struct item*) makeList(mem7, align, alignedSize, nb_elements_per_list);
	

//	rdtscll (before);

	measure_init_();
	measure_start_();
	//	nb_iters = scale_ (n, (float*)(alignedMem), (float*)(alignedMem+alignedSize), (float*)(alignedMem+2*alignedSize), 
	//		(float*)(alignedMem+3*alignedSize), (float*)(alignedMem+4*alignedSize), repetitions);
	nb_iters = scale_ (inner_rep, (struct item*)(alignedMem), repetitions, (struct item*)(alignedMem1), 
			   (struct item*)(alignedMem2), (struct item*)(alignedMem3));
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
	free (mem1);

	return 0;

}
