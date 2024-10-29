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
 real*8, dimension (:, :), allocatable :: arg_a
 real*8, dimension (:), allocatable :: arg_rv1
 real*8 arg_h
 integer arg_i, arg_l, arg_m, arg_n

 !! Argument processing
 paramfile = 'codelet.data'
 record_tmp = '1'
 read (record_tmp, *) record_num
 CALL read_data_file (paramfile, tabdata, 1)
 repeat_value = tabdata (record_num) % repeat_value
 
 !! Codelet variable preparation
 arg_n = tabdata (record_num) % n
 arg_m = 1
 arg_i = 1
 arg_l = 0
 !arg_h = 1
 arg_h = 7.89
 allocate (arg_a (arg_n, arg_m))
 !arg_a = 0
 arg_a = 1.0
 allocate (arg_rv1 (arg_n))
 arg_rv1 = 0
 
 
 !! Codelet call loop
 CALL measure_init()
 CALL measure_start()
 do i = 1, repeat_value
	CALL codelet (arg_n, arg_m, arg_a, arg_i, arg_l, arg_h, arg_rv1)
 end do
 CALL measure_stop()




 deallocate (arg_a, arg_rv1)
 
END PROGRAM codelet_driver
