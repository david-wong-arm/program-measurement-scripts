/*
SUBROUTINE codelet (n, u, rhs, ljsw, foh2, h2i)
  integer n, ljsw, i, ipass, jsw, isw, j
  real*8 u (n, n), rhs (n, n), foh2, h2i, res
  
  res = 7.82
  jsw = ljsw

  do ipass = 1, 2
     jsw = 3 - jsw
     isw = jsw
     do j = 3, n
        isw = 3 - isw
        do i = isw + 2, n, 2
           res =    h2i                         &
                    *                           &
                        (                       &
                            u (j, i + 1) +      &
                            u (j, i - 1) +      &
                            u (j + 1, i) +      &
                            u (j - 1, i) -      &
                            4.0 * u (j, i)      &
                        )                       &
                    +                           &
                        u (j, i) * u (j, i)     &
                    -                           &
                        rhs (j, i)
           u (j, i) =   u (j, i) -              &
                        res /                   &
                            (                   &
                                foh2 +          &
                                2.0 * u (j, i)  &
                            )
        end do
     end do
  end do
  
END SUBROUTINE codelet
*/

int codelet_(int n, double (*u)[n], double (*rhs)[n], int ljsw, double foh2, double h2i);
int codelet_(int n, double (*u)[n], double (*rhs)[n], int ljsw, double foh2, double h2i) {
    int i,ipass, jsw, isw,j;
    double res;

    res = 7.82;
    jsw = ljsw;

    for (ipass=1; ipass<=2; ipass++) {
        jsw = 3 - jsw;
        isw = jsw;
        for (j=3-1; j<n; j++) {
            isw = 3 - isw;
            for (i=isw+2 -1; i<n; i+=2) {
                res = h2i
                    * (
                            u [i + 1][j] +  
                            u [i - 1][j] +  
                            u [i][j + 1] +  
                            u [i][j - 1] -  
                            4.0 * u [i][j] 
                      )
                    +  
                            u [i][j] * u [i][j] 
                    -
                            rhs[i][j];
                u[i][j] = u[i][j] -
                    res /
                        (
                            foh2 +
                            2.0 * u[i][j]
                        );
            }
        }
    }
    /* only approx. */
    return 2*(n-3)*n/2;
}
