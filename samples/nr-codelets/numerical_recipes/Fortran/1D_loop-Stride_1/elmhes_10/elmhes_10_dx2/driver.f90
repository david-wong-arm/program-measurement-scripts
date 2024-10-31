PROGRAM codelet_driver
 USE varGlobales

 IMPLICIT NONE

 TYPE(PARAM),DIMENSION(1) :: tabdata
 integer :: record_num, repeat_value, i, m, n
 character*80 :: paramfile
 character*80 :: record_tmp

 real*8, dimension (:, :), allocatable :: a
 real*8 y
 integer m1, m2

 paramfile='codelet.data'
 record_tmp = '1'

 read(record_tmp,*)record_num
 CALL read_data_file (paramfile, tabdata, 1)

 repeat_value=tabdata(record_num)%repeat_value
 n=tabdata(record_num)%n
 m=10

 allocate(a(n, m))

! CALL getdmatrix (a, n, m)
a = 0

 m1 = 2
 m2 = 10
 y = real (3)

  CALL measure_init()
  CALL measure_start()
 do i=1,repeat_value
	CALL codelet(n, m, a, y, m1, m2)
 end do
 CALL measure_stop()




 deallocate (a)

END PROGRAM codelet_driver
