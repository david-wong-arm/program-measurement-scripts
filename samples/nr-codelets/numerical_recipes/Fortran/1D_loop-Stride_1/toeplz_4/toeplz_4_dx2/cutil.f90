SUBROUTINE getmatrix (A,n,m)

INTEGER :: m, n, i, j
REAL*4,intent ( out ) :: A(n,m)
do i = 1, n
       do j = 1, m
       A(i,j)=int(rand(0)*99)+1
       end do
end do

!PRINT*,n
!DO 100 i=1, n
!     PRINT*, (A(i, j), j=1, m)
!100  CONTINUE

END SUBROUTINE getmatrix

SUBROUTINE getdmatrix (A,n,m)

INTEGER :: m, n, i, j
REAL*8,intent ( out ) :: A(n,m)
do i = 1, n
       do j = 1, m
       A(i,j)=int(rand(0)*99)+1
       end do
end do
END SUBROUTINE getdmatrix

SUBROUTINE readmatrix (inputfile, A, m, n)

CHARACTER*80 inputfile
INTEGER :: m, n, i, j
REAL*4 :: A(n*m,1)

IUNIT = 10
OPEN(IUNIT,FILE=inputfile)
!READ(IUNIT,*) ((A(i, j), j=1, n), i=1, m) 
READ(IUNIT,*) ((A(i, 1)), i=1, m*n)

CLOSE(IUNIT)

END SUBROUTINE readmatrix

SUBROUTINE readdmatrix (inputfile, A, m, n)

CHARACTER*80 inputfile
INTEGER :: m, n, i, j
REAL*8 :: A(m,n)

IUNIT = 10
OPEN(IUNIT,FILE=inputfile)
READ(IUNIT,*) ((A(i, j), j=1, n), i=1, m)
CLOSE(IUNIT)

END SUBROUTINE readdmatrix


SUBROUTINE readimatrix (inputfile, A, m, n)

CHARACTER*80 inputfile
INTEGER :: m, n, i, j
INTEGER :: A(m,n)

IUNIT = 10
OPEN(IUNIT,FILE=inputfile)
READ(IUNIT,*) ((A(i, j), j=1, n), i=1, m)
CLOSE(IUNIT)

END SUBROUTINE readimatrix

SUBROUTINE read_data_file(paramfile, A, n)
USE varGlobales

CHARACTER*80 paramfile
INTEGER :: m, n, i, j
TYPE(PARAM),DIMENSION(n) :: A

IUNIT = 10
OPEN(IUNIT,FILE=paramfile)
READ(IUNIT,*) (A(i), i=1, n)

CLOSE(IUNIT)

END SUBROUTINE read_data_file 


SUBROUTINE affich (A, n, m)

INTEGER :: m, n, i, j
INTEGER :: A(n,m)

DO 100 i=1, n
     PRINT*, (A(i, j), j=1, m)
100  CONTINUE

END SUBROUTINE affich

SUBROUTINE affich_data (A, n)
USE varGlobales

INTEGER :: m, n, i, j
TYPE(PARAM),DIMENSION(n) :: A 

DO 100 i=1, n
     PRINT*, A(i)
100  CONTINUE

END SUBROUTINE affich_data

FUNCTION align_up (original, align) RESULT (up)
  integer :: original, align, up
  up = (original + align - MOD(original, align))
END FUNCTION align_up
