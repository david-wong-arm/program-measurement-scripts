SUBROUTINE codelet (n, m, a, y, g)

  integer n, m, k, y, x
  real*8 g
  real*8 a (n, n)

  do x = 1, n
    do y = 1, n
      a(x,y) = a(x,y) + a(x,y)
    end do
  end do

END SUBROUTINE codelet


