#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "rdtsc.h"
#include "util.h"

#define LINE_SIZE 64
#define NUM_STREAMS 1

unsigned long long scale_ (unsigned long long, struct item*, unsigned int); // Using David Wong's 'in codelet' repetitions





int main (int argc, char** argv)
{
	unsigned int align = 64;
	unsigned long long int before, after;
	unsigned long long nb_elements, repetitions, inner_rep, nb_elements_per_list;
        int shuffle;

	char* mem;
	char* alignedMem;
	float* tab;

	unsigned long long nb_iters;

	int i;
	int n;

        srand(8088);

	if (read_arguments (&nb_elements, &inner_rep, &repetitions, &shuffle) == -1){
		printf ("Failed to load codelet.data!\n");
		return -1;
	}

	printf ("Nb elements: %llu.\n", nb_elements);
	printf ("Nb repetitions: %llu.\n", repetitions);
	printf ("shuffle: %u.\n", shuffle);


        unsigned long long streamSize = sizeof(struct item) * nb_elements;
	unsigned long long alignedSize = alignUp(streamSize, align);
	printf ("AlignedSize: %llu.\n", alignedSize);

	//mem = malloc (sizeof (float) * (nb_elements*5) + 4096);
	mem = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	// printf("alloc-->%p - %p, size=%d\n", mem, (mem+alignedSize+align), alignedSize+align);
	if (mem == NULL)
	{
		printf ("Could not allocate the main array.\n");
		return -1;
	}
	nb_elements_per_list = nb_elements/NUM_STREAMS;
	alignedMem = makeList(mem, align, alignedSize, nb_elements_per_list, shuffle);
	//alignedMem = (char*) alignUp((unsigned long long)mem, align);

	//tab = (float*)(mem - (unsigned long long) mem % 32);
	//tab = tab + 8;  // 8 SP = 32 bytes

	n = nb_elements;
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

//	rdtscll (before);

	measure_init_();
	measure_start_();
	//	nb_iters = scale_ (n, (float*)(alignedMem), (float*)(alignedMem+alignedSize), (float*)(alignedMem+2*alignedSize), 
	//		(float*)(alignedMem+3*alignedSize), (float*)(alignedMem+4*alignedSize), repetitions);
	nb_iters = scale_ (inner_rep, (struct item*)(alignedMem), repetitions);
	measure_stop_();

//	rdtscll (after);
	cnt = (struct item*)alignedMem;
	// printf("last data = %d\n", cnt[n-1].data);

	printf ("Nb iters0: %llu.\n", nb_iters);
	nb_iters /= repetitions;
	printf ("Nb iters1: %llu.\n", nb_iters);
	nb_iters = nb_elements / 8;
	printf ("Nb iters: %llu.\n", nb_iters);
	//printf ("RDTSC: %lf.\n", ((double)(after - before)) / (double)repetitions / (double)nb_iters );

	free (mem);

	return 0;

}
