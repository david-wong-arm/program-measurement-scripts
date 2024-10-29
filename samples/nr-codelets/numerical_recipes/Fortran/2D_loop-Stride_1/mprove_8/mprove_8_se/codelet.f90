SUBROUTINE codelet (n, a, b, x, r)  
   integer n, i, j
   real*4 a (n, n), b(n), x(n), r(n)  
   real*4 sdp  

   do i = 1, n  
      sdp = -b (i)
      do j = 1, n  
         sdp = sdp + a (j, i) * x (j)  
      end do
      r (i) = sdp  
   end do
  
END SUBROUTINE codelet

