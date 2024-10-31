#include <math.h>
/*
SUBROUTINE codelet (n, m, i, a, res) ! m = 20, i = 1

	integer n, j
	real*8 a(m, n), s, res (1)

	s = real (0)

	do j = i, n
		s = s + abs (a (i, j))
	end do

	res (1) = s

END SUBROUTINE codelet
*/

int codelet_(int n, int m, int i, double (*a)[m], double *res);
int codelet_(int n, int m, int i, double (*a)[m], double *res) {
    // m = 20, i = 1 - 1
    int j;
    double s = 0.0;

    for (j=0; j<n; j++) {
        s = s + fabs(a[j][i]);
    }
    *res = s;
    return n;
}
