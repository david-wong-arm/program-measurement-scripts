/*
SUBROUTINE codelet (n, m, a, i, l, scal, res)

  integer m, n, i, l, k
  real*8 a (n, m), res (1), scal, s

  s = res (1)
  do k = l + 1, n
     a (k, i) = a (k, i) / scal
     s = s + a (k, i) * a (k, i)
  end do
  res (1) = s

END SUBROUTINE codelet
*/

int codelet_(int n, int m, double (*a)[n], int i, int l, double scal, double* res);
int codelet_(int n, int m, double (*a)[n], int i, int l, double scal, double* res) {
    int k;
    double s;

    s = *res;
    for (k = l; k<n; k++) {
        a[i][k] = a[i][k] / scal;
        s = s + a[i][k] * a[i][k];
    }
    *res = s;
    return n-l;
}
