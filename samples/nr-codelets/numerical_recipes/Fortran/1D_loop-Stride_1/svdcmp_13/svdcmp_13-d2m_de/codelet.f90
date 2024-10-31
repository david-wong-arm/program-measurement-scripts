SUBROUTINE codelet (n, m, a, i, l, scal, res)

  integer m, n, i, l, k
  real*8 a (n, m), res (1), scal, s, inv_scal

  s = res (1)
  inv_scal = 1/scal
  do k = l + 1, n
     a (k, i) = a (k, i) * inv_scal
     s = s + a (k, i) * a (k, i)
  end do
  res (1) = s

END SUBROUTINE codelet

