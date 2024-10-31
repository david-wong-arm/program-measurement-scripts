SUBROUTINE codelet (n, m, a, y, m1, m2) ! m = 10, y = 3, m1 = 2, m2 = 10

        integer n, m, m1, m2, j
	real*8 a (n, m), y

        do j = 1, n
                a (j, m1) = a (j, m1) + y * a (j, m2)
        end do

END SUBROUTINE codelet

