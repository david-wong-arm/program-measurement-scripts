PROGRAM codelet_driver
 USE varGlobales

 IMPLICIT NONE

 TYPE(PARAM),DIMENSION(1) :: tabdata
 integer :: record_num, repeat_value, i, i1, m, m1, n
 character*80 :: paramfile
 character*80 :: record_tmp

 real*8, dimension (:, :), allocatable :: a
 real*8 :: y

 paramfile='codelet.data'
 record_tmp = '1'

 read(record_tmp,*)record_num
 CALL read_data_file (paramfile, tabdata, 1)

 repeat_value = tabdata(record_num)%repeat_value
 n = tabdata(record_num)%n
 m = 20
 m1 = 2
 i1 = 11
 y = real (3)

 allocate(a(n, m))

! CALL getdmatrix (a, m, n)
a = 0

  CALL measure_init()
  CALL measure_start()
 do i=1,repeat_value
	CALL codelet(n, m, m1, i1, a, y)
 end do
 CALL measure_stop()




 deallocate (a)

END PROGRAM codelet_driver
