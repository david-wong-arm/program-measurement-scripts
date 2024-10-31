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

