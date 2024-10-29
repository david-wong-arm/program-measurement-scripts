#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "rdtsc.h"

int codelet_(int n, double (*u)[n], double (*rhs)[n], int ljsw, double foh2, double h2i);

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
        int arg_ljsw = 1;
        double arg_foh2 = 1.0;
        double arg_h2i = 1.0;

	unsigned long long alignedSize = alignUp(sizeof(double)*arg_n * arg_n, align);
	char* buf = malloc (alignedSize);
	double (*arg_rhs)[arg_n] = (double(*)[arg_n]) buf;
        //double *pp = (double*) buf;
	char* buf_u = malloc (alignedSize);
	double (*arg_u)[arg_n] = (double(*)[arg_n]) buf_u;



	if (!arg_rhs || !arg_u )
	{
		printf ("Could not allocate one of the main arrays.\n");
		return -1;
	}

	memset (arg_rhs, 0, arg_n*arg_n * sizeof(double));

        int j;
        for (i=0; i<arg_n; i++) {
            for (j=0; j<arg_n; j++) {
                arg_u[i][j] = 1.0;
            }
        }


//	rdtscll (before);
 	measure_init_();
        measure_start_();

	for (i = 0; i < repetitions; i++)
	{
		nb_iters += codelet_ (arg_n, arg_u, arg_rhs, arg_ljsw, arg_foh2, arg_h2i);
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
