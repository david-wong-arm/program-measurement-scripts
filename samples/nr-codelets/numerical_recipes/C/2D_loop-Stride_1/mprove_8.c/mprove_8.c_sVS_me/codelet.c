/*
SUBROUTINE codelet (n, a, b, x, r)  
   integer n, i, j
   real*4 a (n, n), b(n), x(n), r(n)  
   real*8 sdp  

   do i = 1, n  
      sdp = -b (i)
      do j = 1, n  
         sdp = sdp + a (j, i) * x (j)  
      end do
      r (i) = sdp  
   end do
  
END SUBROUTINE codelet
*/

int codelet_(int n, float (*a)[n], float b[n], float x[n], float r[n]);
int codelet_(int n, float (*a)[n], float b[n], float x[n], float r[n]) {
    int i,j;
    double sdp;

    for (i=0; i<n; i++) {
        sdp = -b[i];
        for (j=0; j<n; j++) {
            sdp = sdp + a[i][j] * x[j];
        }
        r[i] = sdp;
    }
    return n*n;
}
