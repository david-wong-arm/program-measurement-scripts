/*
SUBROUTINE codelet (n, oute, u, h2i)
  integer n, i, j
  real*8 oute (n, n), u(n, n), h2i

  do j = 3, n
     do i = 3, n
        oute (j, i) =   h2i                 &
                        * (                 &
                            u (j, i + 1) +  &
                            u (j, i - 1) +  &
                            u (j + 1, i) +  &
                            u (j - 1, i) -  &
                            4.0 * u (j, i)  &
                            )               &
                        + (                 &
                            u (j, i) *      &
                            u (j, i)        &
                            )
     end do
  end do
  
END SUBROUTINE codelet
*/

int codelet_(int n, double (*oute)[n], double (*u)[n], double h2i);
int codelet_(int n, double (*oute)[n], double (*u)[n], double h2i) {
    int i,j;

    for (j=2; j<n; j++) {
        for (i=2; i<n; i++) {
            oute[i][j] = h2i
                * (
                        u [i + 1][j] +  
                        u [i - 1][j] +  
                        u [i][j + 1] +  
                        u [i][j - 1] -  
                        4.0 * u [i][j] 
                  )
                + ( 
                        u [i][j] * 
                        u [i][j] 
                  );
        }
    }
    return (n-2)*(n-2);
}
