SUBROUTINE codelet (n,  a, b,c) ! m = 20, i = 1

	integer n,  j, i, k
	real*8 a(n, n), b(n,n), c(n,n)

do i=1,n
 do j = 1, n
   do k = 1, n
       c (i, j) = c(i,j) + a (i, k) * b(k,j)
      end do
    end do
 end do


END SUBROUTINE codelet

