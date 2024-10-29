PROGRAM codelet_driver
 USE varGlobales

 IMPLICIT NONE

 TYPE(PARAM),DIMENSION(1) :: tabdata
 integer :: record_num, repeat_value, i, m, n
 character*80 :: paramfile
 character*80 :: record_tmp

 real*8, dimension (:), allocatable :: dat

 paramfile='codelet.data'
 record_tmp = '1'

 read(record_tmp,*)record_num
 CALL read_data_file (paramfile, tabdata, 1)

 repeat_value=tabdata(record_num)%repeat_value
 n=tabdata(record_num)%n
 m=1


 allocate (dat (2 * n + 2))


! CALL getdmatrix (dat, 2 * n + 2, 1)

dat = 0

  CALL measure_init()
  CALL measure_start()
 do i=1,repeat_value
	CALL codelet(n, dat)
 end do
 CALL measure_stop()




 deallocate (dat)

END PROGRAM codelet_driver
