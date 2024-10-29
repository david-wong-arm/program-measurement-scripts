SUBROUTINE codelet (n, gam, a, b, c, r, u, bet)

	integer n, j
	real*8 bet, inv_bet
	real*8 gam(n), a(n), b(n), c(n), r(n), u(n) 

	inv_bet = 1/bet
	do j = 2, n
		gam (j) = c (j - 1) * inv_bet
		bet = b (j) - a(j) * gam(j)
		inv_bet = 1/bet
		u (j) = (r (j) - a (j) * u (j - 1)) * inv_bet
	end do

END SUBROUTINE codelet

