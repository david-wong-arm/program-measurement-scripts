SUBROUTINE codelet (n, m, r, x, g, m1, res)
  integer n, m, m1, j
  real*8 r (2 * n - 1), x (n), g (n), res (2), sxn, sd

  sxn = res (1)
  sd  = res (2)

  do j = 1, m
    sxn = sxn + r (n - 1 + m1 - j) * x (j)
    sd  = sd  + r (n - 1 + m1 - j) * g (m - j + 1)
  end do
  
  res (1) = sxn;
  res (2) = sd;
  
END SUBROUTINE codelet

