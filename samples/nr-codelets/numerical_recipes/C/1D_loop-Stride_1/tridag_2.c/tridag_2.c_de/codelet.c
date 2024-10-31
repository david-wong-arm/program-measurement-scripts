/*
SUBROUTINE codelet (n, gam, u)

	integer n, j
	real*8 gam(n), u(n) 

	do j = n - 1, 1, -1
		u (j) = u (j) - gam (j + 1) * u (j + 1)
	end do

END SUBROUTINE codelet
*/

int codelet_(int n, double gam[n], double u[n]);
int codelet_(int n, double gam[n], double u[n]) {
    int j;

    for (j=n-2; j>=0; j--) { 
        u [j] = u [j] - gam [j + 1] * u [j + 1];
    }
    return n-1;
}
