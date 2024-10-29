SUBROUTINE codelet (n, m, i, a, res) ! m = 20, i = 1

	integer n, j
	real*8 a(m, n), s, res (1)

	s = real (0)

	do j = i, n
		s = s + abs (a (i, j))
	end do

	res (1) = s

END SUBROUTINE codelet

