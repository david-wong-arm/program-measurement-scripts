PROGRAM codelet_driver
 USE varGlobales

 IMPLICIT NONE

 TYPE(PARAM),DIMENSION(1) :: tabdata
 integer :: record_num, repeat_value, i, i1, m, n
 character*80 :: paramfile
 character*80 :: record_tmp

 real*8, dimension (:, :), allocatable :: a
 real*8, dimension (:), allocatable :: res
 real*8 :: y

 paramfile='codelet.data'
 record_tmp = '1'

 read(record_tmp,*)record_num
 CALL read_data_file (paramfile, tabdata, 1)

 repeat_value = tabdata(record_num)%repeat_value
 n = tabdata(record_num)%n
 m = 20
 i1 = 1




 allocate (a (n, m))
 allocate (res (1))

a = 0

 !CALL getdmatrix (a, m, n)


  CALL measure_init()
  CALL measure_start()
 do i=1,repeat_value
! print *, "Repeat value: ",  repeat_value, "."
	CALL codelet(n, m, i1, a, res)
 end do
 CALL measure_stop()




 deallocate (a)
 deallocate (res)

END PROGRAM codelet_driver
