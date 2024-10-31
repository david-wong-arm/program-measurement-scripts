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
 real*4, dimension (:), allocatable :: arg_dat
 real*8 arg_wr, arg_wpr, arg_wpi, arg_wi
 integer arg_n, arg_nn, arg_n_minus_1, arg_mmax, arg_istep

 !! Argument processing
 paramfile = 'codelet.data'
 record_tmp = '1'
 read (record_tmp, *) record_num
 CALL read_data_file (paramfile, tabdata, 1)
 repeat_value = tabdata (record_num) % repeat_value
 
 !! Codelet variable preparation
 arg_n = tabdata (record_num) % n
 arg_wr = 1
 arg_wpr = 2
 arg_wpi = 3
 arg_wi = 4
 arg_mmax = 2
 arg_istep = 4
 allocate (arg_dat (arg_n))
 arg_dat = 0
 
 
 !! Codelet call loop
 CALL measure_init()
 CALL measure_start()
 do i = 1, repeat_value
	CALL codelet (arg_n, arg_dat, arg_mmax, arg_istep, arg_wr, arg_wpr, arg_wpi, arg_wi)
 end do
 CALL measure_stop()




 deallocate (arg_dat)
 
END PROGRAM codelet_driver