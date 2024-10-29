/*
SUBROUTINE codelet (n, m, i, a, f) ! m = 20, i = 1

	integer n, m, j, i,i1
	real*8 a(m, n), f

    do i1=1,m
 do j = 1, n

       a (i1, j) = a (i1, j) * f
    end do
 end do


END SUBROUTINE codelet
*/

int codelet_(int n, int m, int i, double (*a)[n], double f);
int codelet_(int n, int m, int i, double (*a)[m], double f) {
    int j, i1;

    for (j=0; j<n; j++) {
        for (i1=0; i<m; i++) {
            a[j][i1] = a[j][i1] * f;
        }
    }
    return m*n;
}
