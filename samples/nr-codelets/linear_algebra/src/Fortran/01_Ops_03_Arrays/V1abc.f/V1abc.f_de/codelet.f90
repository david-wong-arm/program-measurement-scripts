SUBROUTINE codelet (n, m, a, b, c, y, g)

  integer n, m, k, y, x
  real*8 g
  real*8 a (n)
  real*8 b (n, n)
  real*8 c (n)

  do x = 1, n
    do y = 1, n
      a(y) = a(y) + b(y,x)*c(x)
    end do
  end do

END SUBROUTINE codelet


