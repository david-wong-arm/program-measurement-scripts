PROGRAM codelet_driver
 USE varGlobales

 IMPLICIT NONE

 TYPE(PARAM),DIMENSION(1) :: tabdata
 integer :: record_num, repeat_value, i, m, n
 character*80 :: paramfile
 character*80 :: record_tmp

 real*8, dimension (:), allocatable :: r
 real*8, dimension (:), allocatable :: g
 real*8, dimension (:), allocatable :: h
 real*8, dimension (:), allocatable :: res

 paramfile='codelet.data'
 record_tmp = '1'

 read(record_tmp,*)record_num
 CALL read_data_file (paramfile, tabdata, 1)

 repeat_value=tabdata(record_num)%repeat_value
 n=tabdata(record_num)%n
 m=1

 allocate (r (2 * n - 1))
 allocate (g (n))
 allocate (h (n))
 allocate (res (3))

! CALL getdmatrix (r, 2 * n - 1, 1)
! CALL getdmatrix (g, n, 1)
! CALL getdmatrix (h, n, 1)
! CALL getdmatrix (res, 3, 1)

r = 0
g = 0
h = 0
res = 0

 ! page 51
  CALL measure_init()
  CALL measure_start()
 do i=1,repeat_value
	CALL codelet(n, r, g, h, res)
 end do
 CALL measure_stop()




 deallocate (r)
 deallocate (g)
 deallocate (h)
 deallocate (res)

END PROGRAM codelet_driver
