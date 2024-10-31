#include <math.h>
/*
SUBROUTINE codelet (n, a, res_floats)
  integer n, res_ints (1), i, j
  real*4 a (n, n), res_floats (1), anorm

  anorm = res_floats (1)
  
  do i = 1, n 
    do j = 1, n
     anorm = anorm + abs (a (j, i))
    end do
  end do
  
  res_floats (1) = anorm
  
  END SUBROUTINE codelet
*/

int codelet_(int n, float (*a)[n], float *res_floats);
int codelet_(int n, float (*a)[n], float *res_floats) {
    int i,j;
    float anorm;

    anorm = *res_floats;

    for (i=0; i<n; i++) {
        for (j=0; j<n; j++) {
            anorm = anorm + fabs (a [i][j]);
        }
    }
    *res_floats = anorm;
    return n*n;
}
