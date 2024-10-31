SUBROUTINE codelet (n, m, a, i, g)

  integer n, m, i, j
  real*8 a (n, m), g

!$OMP DO
  do j = 1, n
     a (j, i) = a (j, i) * g
  end do
!$OMP END DO NOWAIT

END SUBROUTINE codelet

