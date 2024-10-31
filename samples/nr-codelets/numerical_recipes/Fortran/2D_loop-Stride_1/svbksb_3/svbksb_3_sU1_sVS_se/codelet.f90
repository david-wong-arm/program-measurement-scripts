SUBROUTINE codelet (n, v, x, tmp)
  integer n, j, jj
  real*4 v (n, n), x (n), tmp (n), s

  !DEC$ NOUNROLL
  do j = 1, n
    s = 0.0
      !DEC$ NOUNROLL
      do jj = 1, n
        s = s + v (jj, j) * tmp (jj)
      end do
    x (j) = s
  end do
  
END SUBROUTINE codelet

