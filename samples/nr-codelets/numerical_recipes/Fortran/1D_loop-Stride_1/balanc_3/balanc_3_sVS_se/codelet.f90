SUBROUTINE codelet (n, m, a, i, g)

  integer n, m, i, j
  real*4 a (n, m), g

  do j = 1, n
     a (j, i) = a (j, i) * g
  end do

END SUBROUTINE codelet

