SUBROUTINE codelet (n, u, rhs, ljsw, foh2, h2i)
  integer n, ljsw, i, ipass, jsw, isw, j
  real*8 u (n, n), rhs (n, n), foh2, h2i, res
  
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

