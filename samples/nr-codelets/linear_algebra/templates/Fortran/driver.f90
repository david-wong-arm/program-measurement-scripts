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
 #for $var in $vars
 #if $vartypes[$var] == 'A'
 real*8, dimension (:, :), allocatable :: arg_$var
 #else
 real*8, dimension (:), allocatable :: arg_$var
 #end if
 #end for
 real*8 arg_g
 integer arg_i, arg_m, arg_n

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
 arg_g = 1
 #for $var in $vars
 #if $vartypes[$var] == 'A'
 allocate (arg_$var (arg_n, arg_n))
 #else
 allocate (arg_$var (arg_n))
 #end if
 #end for

 #for $var in $vars
 arg_$var = 0
 #end for
 
 
 !! Codelet call loop
 CALL measure_init()
 CALL measure_start()
 do i = 1, repeat_value
#set arg_vars = ['arg_'+v for v in $vars]
#set $args = ', '.join($arg_vars)
	CALL codelet (arg_n, arg_n, $args, arg_i, arg_g)
 end do
 CALL measure_stop()




#for $var in $vars
 deallocate (arg_$var)
#end for
 print *, "repeat_value=" , repeat_value
 print *, "arg_n=" , arg_n
 
END PROGRAM codelet_driver
