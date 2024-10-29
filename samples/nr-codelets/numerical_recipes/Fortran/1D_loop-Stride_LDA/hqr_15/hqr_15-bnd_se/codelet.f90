SUBROUTINE codelet (n, a, x)
  integer n, i
  real*4 a (n, n), x

  ! Try to access array a like a banded matrix
  ! See https://software.intel.com/en-us/mkl-developer-reference-c-matrix-storage-schemes-for-lapack-routines#BAND_STORAGE
  ! row major
  kl=n-1
  do i = 1, n
  !  So row index is the same
     irow=i
     icol=i
     irowb=irow
     icolb=(icol-irow)+kl
     a (irowb, icolb) = a(irowb, icolb) - x
  end do
  
  END SUBROUTINE codelet

