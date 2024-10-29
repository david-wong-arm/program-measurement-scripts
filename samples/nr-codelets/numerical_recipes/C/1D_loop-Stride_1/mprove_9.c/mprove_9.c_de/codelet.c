/*
SUBROUTINE codelet (n, x, r)

	integer n, j
	real*8 x(n), r(n)

	do j = 1, n
		x (j) = x (j) - r (j)
	end do

END SUBROUTINE codelet
*/

int codelet_(int n, double x[n], double r[n]);
int codelet_(int n, double x[n], double r[n]) {
    int j;

    for (j=0; j<n; j++) {
        x[j] = x[j] - r[j];
    }

    return n;
}

