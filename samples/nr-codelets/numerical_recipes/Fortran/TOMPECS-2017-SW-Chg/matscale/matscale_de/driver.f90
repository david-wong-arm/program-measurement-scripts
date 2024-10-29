PROGRAM codelet_driver
 USE varGlobales

 IMPLICIT NONE

 TYPE(PARAM),DIMENSION(1) :: tabdata
 integer :: record_num, repeat_value, i, m, n, i1
 character*80 :: paramfile
 character*80 :: record_tmp

 real*8, dimension (:, :), allocatable :: a
 real*8 :: f

 paramfile='codelet.data'
 record_tmp = '1'

 read(record_tmp,*)record_num
 CALL read_data_file (paramfile, tabdata, 1)

 repeat_value = tabdata(record_num)%repeat_value
 m = tabdata(record_num)%m
 n = tabdata(record_num)%n
 !m = 20
 !m = n
 i1 = 1
 f = real (3)

 allocate(a(m, n))

! CALL getdmatrix (a, n, m)

a = 0

  CALL measure_init()
  CALL measure_start()
 do i=1,repeat_value
	CALL codelet(n, m, i1, a, f)
 end do
 CALL measure_stop()


 deallocate (a)

END PROGRAM codelet_driver
