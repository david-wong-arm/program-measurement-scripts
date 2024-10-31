SUBROUTINE codelet (nc, uc, uf)
  integer nc, ic, jc, jf, iif
  real*8 uf (2*nc-1, 2*nc-1), uc (nc, nc)
! nc = (n + 1) / 2

  jf = 3
  do jc = 3, nc
     iif = 3
     do ic = 3, nc
        uc (jc, ic) =   0.5 * uf (jf, iif) +            &
                        0.125 * (                       &
                                    uf (jf, iif + 1) +  &
                                    uf (jf, iif - 1) +  &
                                    uf (jf + 1, iif) +  &
                                    uf (jf - 1, iif)    &
                                )
        iif = iif + 2
     end do
     jf = jf + 2
  end do
  
END SUBROUTINE codelet

