SUBROUTINE codelet (n, m, a, b, c, y, g)

  integer n, m, k, y, x
  real*8 g
  real*8 a (n, n)
  real*8 b (n, n)
  real*8 c (n, n)

  do x = 1, n
    do y = 1, n
      a(y,x) = b(y,x) * g
      c(y,x) = b(y,x) * g
    end do
  end do

END SUBROUTINE codelet


