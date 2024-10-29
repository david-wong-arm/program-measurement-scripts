/*
SUBROUTINE codelet (n, a, x)
  integer n, i
  real*4 a (n, n), x

  do i = 1, n
     a (i, i) = a(i, i) - x
  end do
  
  END SUBROUTINE codelet
*/

int codelet_(int n, float (*a)[n], float x);
int codelet_(int n, float (*a)[n], float x) {
    int i;

    for (i=0; i<n; i++) {
        a[i][i] = a[i][i] - x;
    }
    return n;
}
