/*
SUBROUTINE codelet (n, g, h, pp, qq)

	integer n, j, m2, k
	real*8 g(n), h(n), pp, qq, pt1, pt2, qt1, qt2

	! pp = qq = real (3.14)

	m2 = n / 2
	k = n

	do j = 1, m2
		pt1 = g (j)
		pt2 = g (k)
		qt1 = h (j)
		qt2 = h (k)
		g (j) = pt1 - pp * qt2
		g (k) = pt2 - pp * qt1
		h (j) = qt1 - qq * pt2
		h (k) = qt2 - qq * pt1
		k = k - 1
	end do

END SUBROUTINE codelet
*/

int codelet_(int n, double g[n], double h[n], double pp, double qq);
int codelet_(int n, double g[n], double h[n], double pp, double qq) {
    int j, m2, k;
    double pt1, pt2, qt1, qt2;

    m2 = n / 2; 
    k = n - 1;

    for (j=0; j<m2; j++) { 
        pt1 = g [j]; 
        pt2 = g [k]; 
        qt1 = h [j]; 
        qt2 = h [k]; 
        g [j] = pt1 - pp * qt2; 
        g [k] = pt2 - pp * qt1; 
        h [j] = qt1 - qq * pt2; 
        h [k] = qt2 - qq * pt1; 
        k = k - 1;
    }
    return m2;
}
