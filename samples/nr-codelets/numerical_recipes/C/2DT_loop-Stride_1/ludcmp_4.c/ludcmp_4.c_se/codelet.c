#include <math.h>
/*
SUBROUTINE codelet (n, a, j)
  real*4 a (n, n), sum
  integer i, j, k, n

  do i = 128, j
    sum = a (j, i)      
    do k = 1, i
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

    for (i=128-1; i<j; i++) {
        sum = a[i][j];
        for (k=0; k<i+1; k++) {
            sum = sum - a[i][k] * a[k][j];
        }
        a[i][j] = sum;
    }
    return (j-128+1)*(j+128)/2;
}
