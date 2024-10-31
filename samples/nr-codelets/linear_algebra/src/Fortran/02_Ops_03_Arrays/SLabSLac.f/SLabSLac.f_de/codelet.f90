SUBROUTINE codelet (n, m, a, b, c, y, g)

  integer n, m, k, y, x
  real*8 g
  real*8 a (n, n)
  real*8 b (n, n)
  real*8 c (n, n)

  do x = 1, n
    do y = 1, n
      a(x,y) = b(x,y) * g
      a(x,y) = c(x,y) * g
    end do
  end do

END SUBROUTINE codelet


