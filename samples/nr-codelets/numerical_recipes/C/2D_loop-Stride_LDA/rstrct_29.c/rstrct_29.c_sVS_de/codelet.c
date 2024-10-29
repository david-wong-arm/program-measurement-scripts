/*
   This is a potential bug in the Fortran version.
   In addition to comparing original code, also see:
https://github.com/localmachineadmin/Numerical-Systems/blob/master/hwk4/rstrc.c

  uf should be bigger uf(2*nc-1, 2*nc-1)

SUBROUTINE codelet (nc, uc, uf)
  integer nc, ic, jc, jf, iif
  real*8 uf (nc, nc), uc (nc, nc)
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
*/

int codelet_(int nc, double (*uc)[nc], double (*uf)[2*nc-1]);
int codelet_(int nc, double (*uc)[nc], double (*uf)[2*nc-1]) {
    int ic,jc,jf,iif;

    jf = 3 - 1;
    for (jc=3-1; jc<nc; jc++) {
        iif = 3 - 1;
        for (ic=3-1; ic<nc; ic++) {
            uc[ic][jc] = 0.5 * uf[iif][jf] + 
                         0.125 * (
                                 uf[iif + 1][jf] +  
                                 uf[iif - 1][jf] +  
                                 uf[iif][jf + 1] +  
                                 uf[iif][jf - 1] 
                                 );
            iif = iif + 2;
        }
        jf = jf + 2;
    }
    return (nc-2)*(nc-2);
}
