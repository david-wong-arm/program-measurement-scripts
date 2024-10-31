#include <math.h>
/*
SUBROUTINE codelet (n, a, j)
  real*4 a (n, n), sum
  integer i, j, k, n

  do i = 1, j 
    sum = a (j, i)      
    do k = 1, j 
      sum = sum - a (k, i) * a (j, k)
    end do
    a (j, i) = sum
  end do
  
END SUBROUTINE codelet
*/

int codelet_(int n, float (*a)[n], int j);
int codelet_(int n, float (*a)[n], int j) {
    int i,k;
    float sum;

    for (i=0; i<j; i++) {
        sum = a[i][j];
        for (k=0; k<j; k++) {
            sum = sum - a[i][k] * a[k][j];
        }
        a[i][j] = sum;
    }
    return j*j;
}
