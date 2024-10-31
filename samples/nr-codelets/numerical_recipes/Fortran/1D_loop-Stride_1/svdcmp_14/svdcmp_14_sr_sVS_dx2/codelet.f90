SUBROUTINE codelet (n, m, a, i, l, h, rv1)

  integer m, n, i, k,l
  real*8 a (n, m), rv1 (n), h

  do k = l + 1, n
     rv1 (k) = a (k, i) / h
  end do

END SUBROUTINE codelet

