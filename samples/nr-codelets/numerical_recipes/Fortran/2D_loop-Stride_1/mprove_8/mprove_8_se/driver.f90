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
 real*4, dimension (:, :), allocatable :: arg_a
 real*4, dimension (:), allocatable :: arg_b, arg_r, arg_x
 integer arg_n

 !! Argument processing
 paramfile = 'codelet.data'
 record_tmp = '1'
 read (record_tmp, *) record_num
 CALL read_data_file (paramfile, tabdata, 1)
 repeat_value = tabdata (record_num) % repeat_value
 
 !! Codelet variable preparation
 arg_n = tabdata (record_num) % n
 allocate (arg_a (arg_n, arg_n))
 arg_a = 0
 allocate (arg_b (arg_n))
 arg_b = 0
 allocate (arg_r (arg_n))
 arg_r = 0
 allocate (arg_x (arg_n))
 arg_x = 0
 
 
 !! Codelet call loop
 CALL measure_init()
 CALL measure_start()
 do i = 1, repeat_value
	CALL codelet (arg_n, arg_a, arg_b, arg_x, arg_r)
 end do
 CALL measure_stop()




 deallocate (arg_a, arg_b, arg_r, arg_x)
 
END PROGRAM codelet_driver
