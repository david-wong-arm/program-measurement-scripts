#include <math.h>
/*
SUBROUTINE codelet (n, m, i, a, res) ! m = 10, i = 1

	integer n, j
	real*8 a(n, m), s, res (1)

	s = real (0)

	do j = 1, n
		s = s + abs (a (j, i))
	end do

	res (1) = s

END SUBROUTINE codelet
*/

int codelet_(int n, int m, int i, double (*a)[n], double *res);
int codelet_(int n, int m, int i, double (*a)[n], double *res) {
    // m = 10, i = 1 - 1

    int j;
    double s = 0.0;
    for (j=0; j<n; j++) {
        s = s + fabs(a[i][j]);
    }
    *res = s;
    return n;
}
