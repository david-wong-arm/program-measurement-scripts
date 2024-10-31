/*
SUBROUTINE codelet (n, m, i, a, f) ! m = 20, i = 1

	integer n, m, j, i
	real*8 a(m, n), f

	do j = 1, n
		a (i, j) = a (i, j) * f
	end do

END SUBROUTINE codelet
*/

int codelet_(int n, int m, int i, double (*a)[m], double f);
int codelet_(int n, int m, int i, double (*a)[m], double f) {
    int j;

    for (j=0; j<n; j++) {
        a[j][i]=a[j][i] * f;
    }
    return n;
}
