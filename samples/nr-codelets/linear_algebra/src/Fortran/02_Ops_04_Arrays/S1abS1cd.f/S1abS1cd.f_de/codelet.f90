SUBROUTINE codelet (n, m, a, b, c, d, y, g)

  integer n, m, k, y, x
  real*8 g
  real*8 a (n, n)
  real*8 b (n, n)
  real*8 c (n, n)
  real*8 d (n, n)

  do x = 1, n
    do y = 1, n
      a(y,x) = b(y,x) * g
      c(y,x) = d(y,x) * g
    end do
  end do

END SUBROUTINE codelet


