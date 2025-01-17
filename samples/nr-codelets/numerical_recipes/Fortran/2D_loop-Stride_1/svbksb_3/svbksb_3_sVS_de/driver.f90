PROGRAM codelet_driver
 USE varGlobales
 IMPLICIT NONE

 !! Argument processing variables
 TYPE(PARAM), DIMENSION(1) :: tabdata
 integer :: record_num, repeat_value
 character*80 :: paramfile
 character*80 :: record_tmp
 
 !! Driver variables
 integer i, j

 !! Codelet variables
 real*8, dimension (:, :), allocatable :: arg_v
 real*8, dimension (:), allocatable :: arg_tmp, arg_x
 integer arg_n

 !! Argument processing
 paramfile = 'codelet.data'
 record_tmp = '1'
 read (record_tmp, *) record_num
 CALL read_data_file (paramfile, tabdata, 1)
 repeat_value = tabdata (record_num) % repeat_value
 
 !! Codelet variable preparation
 arg_n = tabdata (record_num) % n
 allocate (arg_v (arg_n, arg_n))
 arg_v = 0
 allocate (arg_tmp (arg_n))
 arg_tmp = 0
 allocate (arg_x (arg_n))
 arg_x = 0
 
 
 !! Codelet call loop
 CALL measure_init()
 CALL measure_start()
 do i = 1, repeat_value
	CALL codelet (arg_n, arg_v, arg_x, arg_tmp)
 end do
 CALL measure_stop()




 deallocate (arg_v, arg_tmp, arg_x)
 
END PROGRAM codelet_driver
