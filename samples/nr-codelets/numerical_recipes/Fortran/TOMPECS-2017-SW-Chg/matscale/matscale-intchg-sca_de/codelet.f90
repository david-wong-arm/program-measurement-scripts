SUBROUTINE codelet (n, m, i, a, f) ! m = 20, i = 1

	integer n, m, j, i,i1
	real*8 a(m, n), f

 do j = 1, n
    do i1=1,m

       a (i1, j) = a (i1, j) * f
    end do
 end do


END SUBROUTINE codelet

