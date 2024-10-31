#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "rdtsc.h"
#include "util.h"

#define LINE_SIZE 64
#define NUM_STREAMS 7

extern struct item* glo_p5;
extern struct item* glo_p6;
extern struct item* glo_p7;

unsigned long long scale_ (unsigned long long, struct item*, unsigned long long, struct item*, struct item*, struct item*); // Using David Wong's 'in codelet' repetitions
unsigned long long scale1_ (unsigned long long, struct item*, unsigned long long, struct item*, struct item*, struct item*); // Using David Wong's 'in codelet' repetitions







int main (int argc, char** argv)
{
	unsigned int align = 64;
	unsigned long long int before, after;
	unsigned long long nb_elements, repetitions, inner_rep, nb_elements_per_list;
        int shuffle;

	char* mem;
	char* mem1;
	char* mem2;
	char* mem3;
	char* mem4;
	char* mem5;
	char* mem6;
	char* alignedMem;
	char* alignedMem1;
	char* alignedMem2;
	char* alignedMem3;
	float* tab;

	unsigned long long nb_iters;


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


        unsigned long long streamSize = sizeof(struct item) * nb_elements_per_list;
	unsigned long long alignedSize = alignUp(streamSize, align);
	printf ("AlignedSize: %llu.\n", alignedSize);

	//mem = malloc (sizeof (float) * (nb_elements*5) + 4096);
	mem = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem1 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem2 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem3 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem4 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem5 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment
	mem6 = malloc (alignedSize + align);  // added extra align bytes for possible adjustment


	alignedMem = makeList(mem, align, alignedSize, nb_elements_per_list, shuffle);
	alignedMem1 = makeList(mem1, align, alignedSize, nb_elements_per_list, shuffle);
	alignedMem2 = makeList(mem2, align, alignedSize, nb_elements_per_list, shuffle);
	alignedMem3 = makeList(mem3, align, alignedSize, nb_elements_per_list, shuffle);
	glo_p5 = (struct item*) makeList(mem4, align, alignedSize, nb_elements_per_list, shuffle);
	glo_p6 = (struct item*) makeList(mem5, align, alignedSize, nb_elements_per_list, shuffle);
	glo_p7 = (struct item*) makeList(mem6, align, alignedSize, nb_elements_per_list, shuffle);
	

//	rdtscll (before);
	nb_iters = scale1_ (inner_rep, (struct item*)(alignedMem), 1, (struct item*)(alignedMem1), 
			   (struct item*)(alignedMem2), (struct item*)(alignedMem3));

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

	printf ("Nb iters0: %llu.\n", nb_iters);
	nb_iters /= repetitions;
	printf ("Nb iters1: %llu.\n", nb_iters);
	nb_iters = nb_elements / 8;
	nb_iters = nb_iters/2;  // number of streams.  Just to be consistent with original pointer tracing.
	printf ("Nb iters: %llu.\n", nb_iters);
	printf ("RDTSC: %lf.\n", ((double)(after - before)) / (double)repetitions / (double)nb_iters );

	free (mem);
	free (mem1);

	return 0;

}
