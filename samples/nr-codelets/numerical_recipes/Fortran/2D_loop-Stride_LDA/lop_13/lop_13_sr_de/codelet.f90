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

