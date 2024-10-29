#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "rdtsc.h"

int codelet_(int n, int m, int i, double (*a)[n], double f);

unsigned long long alignUp(unsigned long long original, unsigned int align) {
        return (original +align - (original % align));
}


int read_arguments (int* nb_elements,int* repetitions, int* m_size)
{
	FILE* file;

	file = fopen ("codelet.data", "r");

	if (file != NULL)
	{
		int res;

		res = fscanf (file, "%d %d %d", repetitions, nb_elements, m_size);
		if (res != 3)
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
	int nb_elements, repetitions, m_size;


	unsigned long long int nb_iters = 0;

	int i, n;

	if (read_arguments (&nb_elements, &repetitions, &m_size) == -1){
		printf ("Failed to load codelet.data!\n");
		return -1;
	}

	printf ("Nb elements: %d.\n", nb_elements);
	printf ("Nb repetitions: %d.\n", repetitions);

	unsigned int align = 32;

        int arg_n = nb_elements;
        int arg_m = m_size;
        int arg_i1 = 1;
        double arg_f = 3.0;

	unsigned long long alignedSize = alignUp(sizeof(double)*arg_n * arg_m, align);
	char* buf = malloc (alignedSize);
	double (*arg_a)[arg_m] = (double(*)[arg_m]) buf;
        //double *pp = (double*) buf;

	if (!arg_a )
	{
		printf ("Could not allocate one of the main arrays.\n");
		return -1;
	}

	memset (arg_a, 0, arg_n*arg_m * sizeof(double));


//	rdtscll (before);
 	measure_init_();
        measure_start_();

	for (i = 0; i < repetitions; i++)
	{
		nb_iters += codelet_ (arg_n, arg_m, arg_i1, arg_a, arg_f);
	}
        measure_stop_();

        /*
        int k;
        for (k=0; k<2*n; k++) {
            printf("%f ", pp[k]);
        }
        */

//	rdtscll (after);

	nb_iters /= repetitions;

	printf ("Nb iters: %llu.\n", nb_iters);
//	printf ("RDTSC: %lf.\n", ((double)(after - before)) / (double)repetitions / (double)nb_iters );


	return 0;

}
