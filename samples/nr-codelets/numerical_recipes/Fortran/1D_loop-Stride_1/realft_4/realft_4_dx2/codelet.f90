SUBROUTINE codelet (n, dat)

	integer n, j, i, i1, i2, i3, i4, np3
	real*8 dat(2 * n + 2), c1, c2, wr, wi, h1r, h1i, h2r, h2i, wtemp

	c1 = 0.5
	c2 = 0.5
	wi = 0.0

	wr = 123.45	! arbitrary non 0 value
	wi = 6.2831	! arbitrary non 0 value

	np3 = 2 * n + 3

	do i=3,ishft(n,-2)+1
		i1 = i + i - 1
		i2 = 1 + i1
		i3 = np3 - i2
		i4 = 1 + i3
		! removed function calls modifying wr and wi here
		h1r = c1 * (dat(i1) + dat(i3))
		h1i = c1 * (dat(i2) - dat(i4))
		h2r = -c2 * (dat(i2) + dat(i4))
		h2i = c2 * (dat(i1) - dat(i3))
		dat(i1) = h1r + wr * h2r - wi * h2i
		dat(i2) = h1i + wr * h2i + wi * h2r
		dat(i3) = h1r - wr * h2r + wi * h2i
		dat(i4) = -h1i + wr * h2i + wi * h2r
		wtemp = wr
		wr = wtemp * wpr - wi * wpi + wr
		wi = wi * wpr + wtemp * wpi + wi
	end do


END SUBROUTINE codelet

