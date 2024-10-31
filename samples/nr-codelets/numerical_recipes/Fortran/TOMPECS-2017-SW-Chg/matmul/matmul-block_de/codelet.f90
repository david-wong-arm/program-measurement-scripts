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

