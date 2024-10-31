/*
SUBROUTINE codelet (n, m, a, i, l, h, rv1)

  integer m, n, i, k,l
  real*8 a (n, m), rv1 (n), h

  do k = l + 1, n
     rv1 (k) = a (k, i) / h
  end do

END SUBROUTINE codelet
*/

int codelet_(int n, int m, double (*a)[n], int i, int l, double h, double rv1[n]);
int codelet_(int n, int m, double (*a)[n], int i, int l, double h, double rv1[n]) {
    int k;

    for (k=l; k<n; k++) {
        rv1[k] = a[i][k] / h;
    }
    return n-l;
}
