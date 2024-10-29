#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "rdtsc.h"

int codelet_(int n, double r[2*n-1], double g[n], double h[n], double res[3]);

unsigned long long alignUp(unsigned long long original, unsigned int align) {
        return (original +align - (original % align));
}


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


	unsigned long long int nb_iters = 0;

	int i, n;

	if (read_arguments (&nb_elements, &repetitions) == -1){
		printf ("Failed to load codelet.data!\n");
		return -1;
	}

	printf ("Nb elements: %d.\n", nb_elements);
	printf ("Nb repetitions: %d.\n", repetitions);

	unsigned int align = 32;

        int arg_n = nb_elements;

	unsigned long long alignedSize = alignUp(sizeof(double)*arg_n, align);
	char* buf = malloc (alignedSize);
	double *arg_g = (double*) buf;

	unsigned long long alignedSize_r = alignUp(sizeof(double)*(arg_n*2-1), align);
	char* buf_r = malloc (alignedSize);
	double *arg_r = (double*) buf_r;

	unsigned long long alignedSize_h = alignUp(sizeof(double)*arg_n, align);
	char* buf_h = malloc (alignedSize);
	double *arg_h = (double*) buf_h;



	if (!arg_g || !arg_r || !arg_h)
	{
		printf ("Could not allocate one of the main arrays.\n");
		return -1;
	}

	memset (arg_r, 0, (2*arg_n-1) * sizeof(double));
	memset (arg_g, 0, arg_n * sizeof(double));
	memset (arg_h, 0, arg_n * sizeof(double));
        double arg_res[3];
	memset (arg_res, 0, 3 * sizeof(double));


//	rdtscll (before);
 	measure_init_();
        measure_start_();

	for (i = 0; i < repetitions; i++)
	{
		nb_iters += codelet_ (arg_n, arg_r, arg_g, arg_h, arg_res);
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
