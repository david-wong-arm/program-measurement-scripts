#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "rdtsc.h"

int scale_ (int, double*, int); // Using David Wong's 'in codelet' repetitions

int read_arguments (int* nb_elements,int* repetitions)
{
	FILE* file;

	file = fopen ("codelet.data", "r");

	if (file != NULL)
	{
		int res;

		res = fscanf (file, "%d %d", repetitions, nb_elements);
		if (res != 2)
		{
			fclose (file);
			return -1;
		}

		fclose (file);

		return 0;
	}
	return -1;
}


int main (int argc, char** argv)
{
	unsigned long long int before, after;
	int nb_elements, repetitions;

	char* mem;
	double* tab;

	int nb_iters;

	int n;

	if (read_arguments (&nb_elements, &repetitions) == -1){
		printf ("Failed to load codelet.data!\n");
		return -1;
	}

	printf ("Nb elements: %d.\n", nb_elements);
	printf ("Nb repetitions: %d.\n", repetitions);

	mem = malloc (sizeof (double) * (nb_elements + 8) + 4096);
//printf("mem32 = %lld\n", (((unsigned long long)mem) %32));
	if (mem == NULL)
	{
		printf ("Could not allocate the main array.\n");
		return -1;
	}

	tab = (double*)(mem - (unsigned long long) mem % 32);
//printf("tab = %lld\n", (((unsigned long long)tab) %32));

	n = nb_elements;
	memset (tab+4, 1, n * sizeof(double));
	{
		float* tab2 = (float*)tab+4;
		tab2[0] = tab2[1] = tab2[2] = tab2[3] = tab2[4] = tab2[5] = tab2[6] = tab2[7] = 1.0;
	}


//	rdtscll (before);

	measure_init_();
	measure_start_();
//printf("tab+4 = %lld\n", (((unsigned long long)(tab+4)) %32));
	nb_iters = scale_ (n*8, (tab + 4), repetitions);
	measure_stop_();

//	rdtscll (after);


	printf ("Nb iters0: %d.\n", nb_iters);
	nb_iters /= repetitions;
	printf ("Nb iters1: %d.\n", nb_iters);
	nb_iters = nb_elements / 8;
	printf ("Nb iters: %d.\n", nb_iters);
	printf ("RDTSC: %lf.\n", ((double)(after - before)) / (double)repetitions / (double)nb_iters );

	free (mem);

	return 0;

}
