/*
SUBROUTINE codelet (n, m, m1, i, a, y) ! m = 20, m1 = 2, i = 11, y = 3

	integer m1, n, j
	real*8 a(m, n), y

	do j = 1, n
		a (m1, j) = a (m1, j) - y * a (i, j)
	end do

END SUBROUTINE codelet

*/

int codelet_(int n, int m, int m1, int i, double (*a)[m], double y);
int codelet_(int n, int m, int m1, int i, double (*a)[m], double y) {
    int j;

    for (j=0; j<n; j++) {
        a[j][m1]=a[j][m1] + y * a[j][i];
    }
    return n;
}
