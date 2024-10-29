SUBROUTINE codelet (n, x, r)

	integer n, j
	real*8 x(n), r(n)

	do j = 1, n
		x (j) = x (j) - r (j)
	end do

END SUBROUTINE codelet

