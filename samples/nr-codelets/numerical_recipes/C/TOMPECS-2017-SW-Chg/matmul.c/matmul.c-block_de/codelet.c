/*
SUBROUTINE codelet (n, a, b,c, bsize) ! m = 20, i = 1

	integer n, j, i, k, kk, jj, en, bsize
	real*8 a(n, n), b(n,n), c(n,n), csum

! Simple blocking http://csapp.cs.cmu.edu/2e/waside/waside-blocking.pdf

en = bsize * (n/bsize)

do kk=1,en,bsize
  do jj=1,en,bsize
    do ii=1,en,bsize

      do i=ii,ii+bsize-1
       do j = jj, jj+bsize-1
         csum = c(i,j)
         do k = kk, kk+bsize-1
             csum = csum + a (i, k) * b(k,j)
         end do
         c(i,j) = csum
       end do
     end do

    end do
  end do
end do


END SUBROUTINE codelet
*/

int codelet_(int n, double (*a)[n], double (*b)[n], double (*c)[n], int bsize);
int codelet_(int n, double (*a)[n], double (*b)[n], double (*c)[n], int bsize) {
    int i,j,k, ii, kk, jj, en;
    double csum;

    en = bsize * (n/bsize);

    for (kk=0; kk<en; kk+=bsize) {
        for (jj=0; jj<en; jj+=bsize) {
            for (ii=0; ii<en; ii+=bsize) {

                for (i=ii; i<ii+bsize; i++) {
                    for (j=jj; j<jj+bsize; j++) {
                        csum = c[j][i];
                        for (k=kk; k<kk+bsize; k++) {
                            csum = csum + a[k][i] * b[j][k];
                        }
                        c[j][i] = csum;
                    }
                }

            }
        }
    }

    return (en/bsize)*(en/bsize)*(en/bsize)*bsize*bsize*bsize;
}
