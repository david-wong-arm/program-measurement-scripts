SUBROUTINE codelet (n, m, a, b, y, g)

  integer n, m, k, y, x
  real*8 g
  real*8 a (n, n)
  real*8 b (n, n)

  do x = 1, n
    do y = 1, n
      do k = 1, n
        a(x,y) = a(x,y) + a(x,k)*b(k,y)
      end do
    end do
  end do

END SUBROUTINE codelet


