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

