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
	if (mem == NULL)
	{
		printf ("Could not allocate the main array.\n");
		return -1;
	}

	//	tab = (double*)(mem + (unsigned long long) mem % 32);
	tab = (double*)(mem - (unsigned long long) mem % 64 + 64);

	n = nb_elements;
	memset (tab, 0, n * sizeof(double));


	rdtscll (before);

	nb_iters = scale_ (n, tab, repetitions);

	rdtscll (after);


	nb_iters /= repetitions;
	nb_iters = nb_elements / 2;
	printf ("Nb iters: %d.\n", nb_iters);
	printf ("RDTSC: %lf.\n", ((double)(after - before)) / (double)repetitions / (double)nb_iters );

	free (mem);

	return 0;

}
