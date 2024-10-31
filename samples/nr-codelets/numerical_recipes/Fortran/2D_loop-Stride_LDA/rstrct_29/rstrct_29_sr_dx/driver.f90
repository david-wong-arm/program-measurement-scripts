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
 real*8, dimension (:, :), allocatable :: arg_uc, arg_uf
 integer n, arg_nc

 !! Argument processing
 paramfile = 'codelet.data'
 record_tmp = '1'
 read (record_tmp, *) record_num
 CALL read_data_file (paramfile, tabdata, 1)
 repeat_value = tabdata (record_num) % repeat_value
 
 !! Codelet variable preparation
 n = tabdata (record_num) % n
 arg_nc = (n + 1) / 2
 allocate (arg_uc (arg_nc, arg_nc))
 arg_uc = 0
 allocate (arg_uf (n, n))
 arg_uf = 0
 
 
 !! Codelet call loop
 CALL measure_init()
 CALL measure_start()
 do i = 1, repeat_value
	CALL codelet (arg_nc, arg_uc, arg_uf)
 end do
 CALL measure_stop()




 deallocate (arg_uc, arg_uf)
 
END PROGRAM codelet_driver