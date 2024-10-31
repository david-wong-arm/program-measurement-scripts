PROGRAM codelet_driver
 USE varGlobales

 IMPLICIT NONE

 TYPE(PARAM),DIMENSION(1) :: tabdata
 integer :: record_num, repeat_value, i, m, n
 character*80 :: paramfile
 character*80 :: record_tmp

! real*8, dimension (:), allocatable :: x
! real*8, dimension (:), allocatable :: r
 real*8, pointer :: xr(:), x(:), r(:)


 paramfile='codelet.data'
 record_tmp = '1'

 read(record_tmp,*)record_num
 CALL read_data_file (paramfile, tabdata, 1)

 repeat_value=tabdata(record_num)%repeat_value
 n=tabdata(record_num)%n
 m=1

! allocate(x(n))
! allocate(r(n))
 allocate(xr(2*n))

! CALL getdmatrix (x, n, 1)
! CALL getdmatrix (r, n, 1)
!x = 0
!r = 0
xr = 0
x=>xr(1:n)
r=>xr((n+1):(2*n))

  CALL measure_init()
  CALL measure_start()
 do i=1,repeat_value
	CALL codelet(n, x, r)
 end do
 CALL measure_stop()




! deallocate (x)
! deallocate (r)
 deallocate (xr)

END PROGRAM codelet_driver
