SUBROUTINE codelet (n, m, a, i, g)

  integer n, m, i, j
  real*8 a (n, m), g

  do j = 1, n
!     call mm_prefetch (a(j+28, i), 2)
!     call mm_prefetch (a(j, i), 2)
     call mm_prefetch (a(j+56, i), 2)
     a (j, i) = a (j, i) * g
  end do

END SUBROUTINE codelet

