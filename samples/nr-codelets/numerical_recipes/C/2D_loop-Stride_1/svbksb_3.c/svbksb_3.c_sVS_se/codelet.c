/*
SUBROUTINE codelet (n, v, x, tmp)
  integer n, j, jj
  real*8 v (n, n), x (n), tmp (n), s

  do j = 1, n
    s = 0.0
      do jj = 1, n
        s = s + v (jj, j) * tmp (jj)
      end do
    x (j) = s
  end do
  
END SUBROUTINE codelet
*/

int codelet_(int n, float (*v)[n], float x[n], float tmp[n]);
int codelet_(int n, float (*v)[n], float x[n], float tmp[n]) {
    int j,jj;
    float s;

    for (j=0; j<n; j++) {
        s = 0.0;
        for (jj=0; jj<n; jj++) {
            s = s + v[j][jj] * tmp[jj];
        }
        x[j] = s;
    }
    return n*n;
}
