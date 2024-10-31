/*
SUBROUTINE codelet (n, gam, a, b, c, r, u, bet)

	integer n, j
	real*8 bet
	real*8 gam(n), a(n), b(n), c(n), r(n), u(n) 

	do j = 2, n
		gam (j) = c (j - 1) / bet
		bet = b (j) - a(j) * gam(j)
		u (j) = (r (j) - a (j) * u (j - 1)) / bet
	end do

END SUBROUTINE codelet
*/

int codelet_(int n, double gam[n], double a[n], double b[n], double c[n], 
        double r[n], double u[n], double bet);
int codelet_(int n, double gam[n], double a[n], double b[n], double c[n], 
        double r[n], double u[n], double bet) {
    int j;

    for (j=1; j<n; j++) { 
        gam [j] = c [j - 1] / bet; 
        bet = b [j] - a[j] * gam[j]; 
        u [j] = (r [j] - a [j] * u [j - 1]) / bet;
    }
    return n-1;
}
