SUBROUTINE codelet (n, m, i, a, f) ! m = 20, i = 1

	integer n, m, j, i
	real*8 a(m, n), f

	do j = 1, n
		a (i, j) = a (i, j) * f
	end do

END SUBROUTINE codelet

