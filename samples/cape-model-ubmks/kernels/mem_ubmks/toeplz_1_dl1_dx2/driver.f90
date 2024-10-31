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
 real*8, dimension (:), allocatable :: arg_g, arg_r, arg_x
 real*8, dimension (2) :: arg_res
 integer arg_m1, arg_m, arg_n

 !! Argument processing
 paramfile = 'codelet.data'
 record_tmp = '1'
 read (record_tmp, *) record_num
 CALL read_data_file (paramfile, tabdata, 1)
 repeat_value = tabdata (record_num) % repeat_value
 
 !! Codelet variable preparation
 arg_n = tabdata (record_num) % n
 arg_m = arg_n - 1
 arg_m1 = 1
 allocate (arg_g (arg_n))
 arg_g = 0
 allocate (arg_r (arg_n * 2))
 arg_r = 0
 allocate (arg_x (arg_n))
 arg_x = 0
 arg_res = 0

 
 !! Codelet call loop
 CALL measure_init()
 CALL measure_start()
 do i = 1, repeat_value
	CALL codelet (arg_n, arg_m, arg_r, arg_x, arg_g, arg_m1, arg_res)
 end do
 CALL measure_stop()




 deallocate (arg_g, arg_r, arg_x)
 
END PROGRAM codelet_driver