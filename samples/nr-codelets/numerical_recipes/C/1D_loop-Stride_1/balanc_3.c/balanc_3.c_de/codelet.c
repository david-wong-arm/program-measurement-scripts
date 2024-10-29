/*
SUBROUTINE codelet (n, m, a, i, g)

  integer n, m, i, j
  real*8 a (n, m), g

  do j = 1, n
     a (j, i) = a (j, i) * g
  end do

END SUBROUTINE codelet
*/

int codelet_ (int n, int, double(*a)[n], int, double);
int codelet_(int n, int m, double (*a)[n], int i, double g) {

    int j;
    for (j=0; j<n; j++) {
        a[i][j]=a[i][j]*g;
    }
    return n;
}
