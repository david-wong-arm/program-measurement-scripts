PROGRAM codelet_driver
 USE varGlobales

 IMPLICIT NONE

 TYPE(PARAM),DIMENSION(1) :: tabdata
 integer :: record_num, repeat_value, i, m, n
 character*80 :: paramfile
 character*80 :: record_tmp

 real*8, dimension (:), allocatable :: g
 real*8, dimension (:), allocatable :: x
 integer m1

 paramfile='codelet.data'
 record_tmp = '1'

 read(record_tmp,*)record_num
 CALL read_data_file (paramfile, tabdata, 1)

 repeat_value=tabdata(record_num)%repeat_value
 n=tabdata(record_num)%n
 m=1

 allocate(g(n))
 allocate(x(n))

! CALL getdmatrix (g, n, 1)
! CALL getdmatrix (x, n, 1)

g = 0
x = 0

 m1 = 1

  CALL measure_init()
  CALL measure_start()
 do i=1,repeat_value
	CALL codelet(n, g, x, m1)
 end do
 CALL measure_stop()




 deallocate (g)
 deallocate (x)

END PROGRAM codelet_driver
