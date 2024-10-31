SUBROUTINE codelet (n, dat, mmax, istep, wr, wpr, wpi, wi)
  integer n, mmax, istep, i, j, m, nn
  real*4 dat (n), tempi, tempr
  real*8 wr, wpr, wpi, wi, wtemp
  
  nn = n - mmax - 1

  do m = 2, mmax, 2
     do i = m, nn, istep
        j = i + mmax
        tempr = wr * dat (j) - wi * dat (j + 1)
        tempi = wr * dat (j + 1) + wi * dat (j)
        dat (j) = dat(i) - tempr
        dat (j + 1) = dat (i + 1) - tempi
        dat (i) = dat (i) + tempr
        dat (i + 1) = dat (i + 1) + tempi
     end do
     wtemp = wr
     wr = wtemp * wpr - wi * wpi + wr
     wi = wi * wpr + wtemp * wpi + wi
  end do
  
  END SUBROUTINE codelet

