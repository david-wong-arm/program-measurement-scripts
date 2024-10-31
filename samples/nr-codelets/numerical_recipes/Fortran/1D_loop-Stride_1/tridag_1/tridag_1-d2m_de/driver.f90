PROGRAM codelet_driver
 USE varGlobales

 IMPLICIT NONE

 TYPE(PARAM),DIMENSION(1) :: tabdata
 integer :: record_num, repeat_value, i, m, n
 character*80 :: paramfile
 character*80 :: record_tmp

 real*8 bet 
 real*8, dimension (:), allocatable :: gam
 real*8, dimension (:), allocatable :: a
 real*8, dimension (:), allocatable :: b
 real*8, dimension (:), allocatable :: c
 real*8, dimension (:), allocatable :: r
 real*8, dimension (:), allocatable :: u

 paramfile='codelet.data'
 record_tmp = '1'

 read(record_tmp,*)record_num
 CALL read_data_file (paramfile, tabdata, 1)

 repeat_value=tabdata(record_num)%repeat_value
 n=tabdata(record_num)%n
 m=1

 allocate(gam(n))
 allocate(a(n))
 allocate(b(n))
 allocate(c(n))
 allocate(r(n))
 allocate(u(n))

!! CALL getdmatrix (gam, n, 1)
! CALL getdmatrix (a, n, 1)
! CALL getdmatrix (b, n, 1)
!! CALL getdmatrix (c, n, 1)
!! CALL getdmatrix (r, n, 1)
!! CALL getdmatrix (u, n, 1)

 do i = 1, n
	gam (i) = real (0)
	a (i) = real (1.001)
!	b (i) = real (1)
	b (i) = real (7.89)
!	c (i) = real (0)
	c (i) = real (1)
!	r (i) = real (0)
	r (i) = real (1)
	u (i) = real (1.0000005)
 end do

 bet = real (1.0000003)


  CALL measure_init()
  CALL measure_start()
 do i=1,repeat_value
	CALL codelet(n, gam, a, b, c, r, u, bet)
 end do
 CALL measure_stop()




 deallocate (gam)
 deallocate (a)
 deallocate (b)
 deallocate (c)
 deallocate (r)
 deallocate (u)

END PROGRAM codelet_driver
