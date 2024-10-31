/*
SUBROUTINE codelet (n, g, x, m1)	! m1 = 1

	integer n, j, m1
	real*8 g(n), x(n)

	do j = 1, n
		x (j) = x (j) - (x (m1) * g (n - j + 1))
	end do

END SUBROUTINE codelet
*/

int codelet_(int n, double g[n], double x[n], int m1);
int codelet_(int n, double g[n], double x[n], int m1) {
    int j;

    for (j=1; j<=n; j++) { 
        x [j-1] = x [j-1] - (x [m1-1] * g [n - j]);
    }
    return n;
}
