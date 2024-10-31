SUBROUTINE codelet (n, a, b, c)
  integer i, j, n
  real*8 a (n, n), b (n, n), c (n, n)

  do j = 1, n
    do i = 1, n
      c (j, i) = a (j, i) + b (j, i)
    end do
  end do
  
END SUBROUTINE codelet

