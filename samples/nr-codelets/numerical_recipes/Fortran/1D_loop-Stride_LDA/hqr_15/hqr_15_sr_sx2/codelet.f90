SUBROUTINE codelet (n, a, x)
  integer n, i
  real*4 a (n, n), x

  do i = 1, n
     a (i, i) = a(i, i) - x
  end do
  
  END SUBROUTINE codelet

