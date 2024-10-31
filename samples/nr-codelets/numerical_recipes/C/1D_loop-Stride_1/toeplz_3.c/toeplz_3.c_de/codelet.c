/*
SUBROUTINE codelet (n, r, g, h, res)

	integer n, m, m1, j
	real*8 r (2 * n - 1), g (n), h (n), res (3), sgn, shn, sgd

	m = n / 2
	m1 = m + 1

	sgn = -r (n - m1)
	shn = -r (n + m1)
	sgd = -r (n)

	do j = 1, m
		sgn = sgn + r (n + j - m1) * g (j)
		shn = shn + r (n + m1 - j) * h (j)
		sgd = sgd + r (n + j - m1) * h (m - j + 1)
	end do

	res (1) = sgn
	res (2) = shn
	res (3) = sgd

END SUBROUTINE codelet
*/

int codelet_(int n, double r[2*n-1], double g[n], double h[n], double res[3]);
int codelet_(int n, double r[2*n-1], double g[n], double h[n], double res[3]) {
    int m, m1, j;
    double sgn, shn, sgd; 
    
    m = n / 2; 
    m1 = m + 1; 
    
    sgn = -r [n - m1 - 1]; 
    shn = -r [n + m1 - 1]; 
    sgd = -r [n - 1];

    for (j=1; j<=m; j++) { 
        sgn = sgn + r [n + j - m1 - 1] * g [j - 1]; 
        shn = shn + r [n + m1 - j - 1] * h [j - 1]; 
        sgd = sgd + r [n + j - m1 - 1] * h [m - j + 1 - 1];
    }
    res[0] = sgn;
    res[1] = shn;
    res[2] = sgd;
    return m;
}
