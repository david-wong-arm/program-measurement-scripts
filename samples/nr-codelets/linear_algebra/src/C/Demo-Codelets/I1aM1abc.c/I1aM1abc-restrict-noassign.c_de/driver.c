#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "rdtsc.h"

//int codelet_ (int n, int m, int o, double (*a)[n], double (*b)[n], double (*c)[o], int, double);
/* int codelet_ (int n, int, double(*a)[n], int, double); */
int codelet_ (int n, int m, int o, double a[__restrict n][m], double b[__restrict n][o], double c[__restrict o][n]);


void measure_init_();
void measure_start_();
void measure_stop_();

unsigned long long alignUp(unsigned long long original, unsigned int align) {
        return (original +align - (original % align));
}


int read_arguments (int* nb_elements, int* mb_elements, int* ob_elements, int* repetitions)
{
	FILE* file;

	file = fopen ("codelet.data", "r");

	if (file != NULL)
	{
		int res;

		res = fscanf (file, "%d %d %d %d", repetitions, nb_elements, mb_elements, ob_elements);
		if (res != 4)
		{
			fclose (file);
			return -1;
		}

		fclose (file);

		return 0;
	}
	return -1;
}


int m, n, o;
int iii, jjj, kkk;
/*
double (*a)[900];
double (*b)[900];
double (*c)[1200];
double a[900][1100];
double b[900][1200];
double c[1200][1100];
*/
/*
double a[3][4]; 
double b[3][5]; 
double c[5][4]; 
*/



int main (int argc, char** argv)
{
	unsigned long long int before, after;
	int nb_elements, repetitions;
	int mb_elements, ob_elements;


	unsigned long long int nb_iters = 0;

	int i;

	if (read_arguments (&nb_elements, &mb_elements, &ob_elements, &repetitions) == -1){
		printf ("Failed to load codelet.data!\n");
		return -1;
	}

	printf ("Nb elements: %d x %d x %d.\n", nb_elements, mb_elements, ob_elements);
	printf ("Nb repetitions: %d.\n", repetitions);

	unsigned int align = 32;
        m = mb_elements;
	n = nb_elements;
        o = ob_elements;
        double g = 1.0;

	unsigned long long alignedSize = alignUp(sizeof(double)*n*m, align);
	unsigned long long alignedSize1 = alignUp(sizeof(double)*n*o, align);
	unsigned long long alignedSize2 = alignUp(sizeof(double)*o*m, align);

        double (*a)[m] = (double(*)[m]) malloc (alignedSize);
        double (*b)[o] = (double(*)[o]) malloc (alignedSize1);
        double (*c)[m] = (double(*)[m]) malloc (alignedSize2);

        /*
	a = (double(*)[n]) malloc (alignedSize);
	b = (double(*)[n]) malloc (alignedSize1);
	c = (double(*)[o]) malloc (alignedSize2);
        */

	if (!a||!b||!c)
	{
		printf ("Could not allocate one of the main arrays.\n");
		return -1;
	}

	memset (a, 0, n * m * sizeof(double));
	memset (b, 0, n * o * sizeof(double));
	memset (c, 0, o * m * sizeof(double));

        {
            int ii, jj;
            int cc = 1;
            for (ii=0; ii<n; ii++) {
#ifdef DEBUG
                printf("b[%d][*]=", ii);
#endif
                for (jj=0; jj<o; jj++) {
                    b[ii][jj]=cc++;
#ifdef DEBUG
                    printf("%.0f\t", b[ii][jj]);
#endif
                }
#ifdef DEBUG
                printf("\n");
#endif
            }
            for (ii=0; ii<o; ii++) {
#ifdef DEBUG
                printf("c[%d][*]=", ii);
#endif
                for (jj=0; jj<m; jj++) {
                    c[ii][jj]=cc++;
#ifdef DEBUG
                    printf("%.0f\t", c[ii][jj]);
#endif
                }
#ifdef DEBUG
                printf("\n");
#endif
            }
        }

 	measure_init_();
        measure_start_();

	for (i = 0; i < repetitions; i++)
	{
		nb_iters += codelet_ (n, m, o, a,b,c);
		//nb_iters += codelet_();
	}
        measure_stop_();
        {
            int ii, jj;
            double csum = 0;
            for (ii=0; ii<n; ii++) {
#ifdef DEBUG
                printf("a[%d][*]=", ii);
#endif
                for (jj=0; jj<m; jj++) {
                    csum += a[ii][jj];
#ifdef DEBUG
                    printf("%.0f\t", a[ii][jj]);
#endif
                }
#ifdef DEBUG
                printf("\n");
#endif
            }
            printf ("Check sum = %.0f\n", csum);
        }

	return 0;

}

