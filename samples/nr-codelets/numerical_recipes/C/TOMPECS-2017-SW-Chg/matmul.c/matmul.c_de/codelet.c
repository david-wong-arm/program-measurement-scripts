/*
SUBROUTINE codelet (n,  a, b,c) ! m = 20, i = 1

	integer n,  j, i, k
	real*8 a(n, n), b(n,n), c(n,n)

do i=1,n
 do j = 1, n
   do k = 1, n
       c (i, j) = c(i,j) + a (i, k) * b(k,j)
      end do
    end do
 end do


END SUBROUTINE codelet
*/

int codelet_(int n, double (*a)[n], double (*b)[n], double (*c)[n]);
int codelet_(int n, double (*a)[n], double (*b)[n], double (*c)[n]) {
    int i,j,k;

    for (i=0; i<n; i++) {
        for (j=0; j<n; j++) {
            for (k=0; k<n; k++) {
                c[j][i] = c[j][i] + a[k][i] * b[j][k];
            }
        }
    }
    return n*n*n;
}
