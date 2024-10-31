SUBROUTINE codelet (n, a, j)
  real*4 a (n, n), sum
  integer i, j, k, n

  do i = 1, j 
    sum = a (j, i)      
    do k = 1, j 
      sum = sum - a (k, i) * a (j, k)
    end do
    a (j, i) = sum
  end do
  
END SUBROUTINE codelet

