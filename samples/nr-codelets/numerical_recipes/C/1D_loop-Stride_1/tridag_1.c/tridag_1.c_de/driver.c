#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "rdtsc.h"

int codelet_(int n, double gam[n], double a[n], double b[n], double c[n], 
        double r[n], double u[n], double bet);

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
	double *arg_gam = (double*) buf;

	char* buf_a = malloc (alignedSize);
	double *arg_a = (double*) buf_a;

	char* buf_b = malloc (alignedSize);
	double *arg_b = (double*) buf_b;

	char* buf_c = malloc (alignedSize);
	double *arg_c = (double*) buf_c;

	char* buf_r = malloc (alignedSize);
	double *arg_r = (double*) buf_r;

	char* buf_u = malloc (alignedSize);
	double *arg_u = (double*) buf_u;


	if (!arg_gam || !arg_a || !arg_b || !arg_c || !arg_r || !arg_u)
	{
		printf ("Could not allocate one of the main arrays.\n");
		return -1;
	}



        for (i=0; i<n; i++) {
            arg_gam [i] = 0;
            arg_a [i] = 1.001; 
            /*  b [i] = real (1) */ 
            arg_b [i] = 7.89;
            /* !       c [i] = real (0) */
            arg_c [i] = 1;
            /* !       r [i] = real (0) */
            arg_r [i] = 1;
            arg_u [i] = 1.0000005;
        }
                                                 
        double arg_bet = 1.0000003;
                                                  
                                                  //	rdtscll (before);
 	measure_init_();
        measure_start_();

	for (i = 0; i < repetitions; i++)
	{
		nb_iters += codelet_ (arg_n, arg_gam, arg_a, arg_b, arg_c, 
                        arg_r, arg_u, arg_bet);
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
