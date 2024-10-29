PROGRAM codelet_driver
 USE varGlobales

 IMPLICIT NONE

 TYPE(PARAM),DIMENSION(1) :: tabdata
 integer :: align_up
 integer :: record_num, repeat_value, i, m, n, align, aligned_size
 character*80 :: paramfile
 character*80 :: record_tmp

! real*8, dimension (:), allocatable :: gam
! real*8, dimension (:), allocatable :: u
 real*8, pointer :: A(:), gam(:), u(:), dummy
 paramfile='codelet.data'
 record_tmp = '1'

 read(record_tmp,*)record_num
 CALL read_data_file (paramfile, tabdata, 1)

 repeat_value=tabdata(record_num)%repeat_value
 n=tabdata(record_num)%n
 m=1

! allocate(gam(n))
! allocate(u(n))
 align=32

 aligned_size=align_up(n*sizeof(dummy), align)/sizeof(dummy)

! allocate(A(2*n))
 allocate(A(2*aligned_size))

! CALL getdmatrix (gam, n, 1)
! CALL getdmatrix (u, n, 1)

!gam = 0
!u = 0
A = 0
gam=>A(1:n)
!u=>A((n+1):(2*n))
u=>A((aligned_size+1):(aligned_size+n))

  CALL measure_init()
  CALL measure_start()
 do i=1,repeat_value
	CALL codelet(n, gam, u)
 end do
 CALL measure_stop()




! deallocate (gam)
! deallocate (u)
 deallocate (A)

END PROGRAM codelet_driver
