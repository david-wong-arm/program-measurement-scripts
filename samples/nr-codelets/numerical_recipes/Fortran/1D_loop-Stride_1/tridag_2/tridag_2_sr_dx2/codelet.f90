SUBROUTINE codelet (n, gam, u)

	integer n, j
	real*8 gam(n), u(n) 

	do j = n - 1, 1, -1
		u (j) = u (j) - gam (j + 1) * u (j + 1)
	end do

END SUBROUTINE codelet

