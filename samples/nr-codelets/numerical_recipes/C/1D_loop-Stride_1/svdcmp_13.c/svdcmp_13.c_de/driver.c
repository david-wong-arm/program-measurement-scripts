#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "rdtsc.h"

int codelet_(int n, int m, double (*a)[n], int i, int l, double scal, double* res);

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

	n = nb_elements;
        int arg_m = 1;
        int arg_i = 1;
        int arg_l = 0;
        double arg_scal = 1.0000003;
        double arg_res = 0;
        double g = 1.0;
       


	unsigned long long alignedSize = alignUp(sizeof(double)*(arg_m*nb_elements), align);
	char* buf = malloc (alignedSize);
	double (*a)[n] = (double(*)[n]) buf;
        //double *pp = (double*) buf;



	if (!a)
	{
		printf ("Could not allocate one of the main arrays.\n");
		return -1;
	}

        int j;
	memset (a, 0, n * sizeof(double));
        for (i = 0; i<arg_m; i++) { 
            for (j = 0; j<n; j++) {
                a[i][j] = 1.0;
            }
        }


//	rdtscll (before);
 	measure_init_();
        measure_start_();

	for (i = 0; i < repetitions; i++)
	{
		nb_iters += codelet_ (n, arg_m, a, arg_i-1, arg_l, arg_scal, &arg_res);
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