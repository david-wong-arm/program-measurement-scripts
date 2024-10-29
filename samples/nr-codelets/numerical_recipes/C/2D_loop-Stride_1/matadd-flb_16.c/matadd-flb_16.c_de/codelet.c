/*
SUBROUTINE codelet (n, a, b, c)
  integer i, j, n
  real*8 a (n, n), b (n, n), c (n, n)

  do j = 1, n
    do i = 1, n
      c (j, i) = a (j, i) + b (j, i)
    end do
  end do
  
END SUBROUTINE codelet
*/

int codelet_(int n, double (*a)[n], double (*b)[n], double (*c)[n]);
int codelet_(int n, double (*a)[n], double (*b)[n], double (*c)[n]) {
    int i,j;

    for (j=0; j<n; j++) {
        for (i=0; i<n; i++) {
            c[i][j] = a[i][j] + b[i][j];
        }
    }
    return n*n;
}
