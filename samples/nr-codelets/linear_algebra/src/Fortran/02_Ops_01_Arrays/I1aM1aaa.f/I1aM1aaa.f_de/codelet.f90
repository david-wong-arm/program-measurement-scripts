SUBROUTINE codelet (n, m, a, y, g)

  integer n, m, k, y, x
  real*8 g
  real*8 a (n, n)

  do x = 1, n
    do y = 1, n
      a(y,x) = 0
      do k = 1, n
        a(y,x) = a(y,x) + a(y,k)*a(k,x)
      end do
    end do
  end do

END SUBROUTINE codelet


