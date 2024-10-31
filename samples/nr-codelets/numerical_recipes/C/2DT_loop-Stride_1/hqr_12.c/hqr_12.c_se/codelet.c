#include <math.h>
// from original nrutil.h
static int imaxarg1,imaxarg2;
#define IMAX(a,b) (imaxarg1=(a),imaxarg2=(b),(imaxarg1) > (imaxarg2) ?\
                (imaxarg1) : (imaxarg2))
/*
SUBROUTINE codelet (n, a, res_floats)
  integer n, res_ints (1), i, j
  real*4 a (n, n), res_floats (1), anorm

  anorm = res_floats (1)
  
  do i = 1, (n - 128)
    do j = max (1, i - 1) + 1, n
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

    for (i=0; i<n-128; i++) {
        for (j=IMAX(0, i-2)+1; j<n; j++) {
            anorm = anorm + fabs (a [i][j]);
        }
    }
    *res_floats = anorm;
    // non precise count
    return (n-128)*n/2;
}
