SUBROUTINE codelet (n, m, a, b, y, g)

  integer n, m, k, y, x
  real*8 g
  real*8 a (n, n)
  real*8 b (n, n)

  do x = 1, n
    do y = 1, n
      a(y,x) = 0
      do k = 1, n
        a(y,x) = a(y,x) + b(y,k)*b(k,x)
      end do
    end do
  end do

END SUBROUTINE codelet


