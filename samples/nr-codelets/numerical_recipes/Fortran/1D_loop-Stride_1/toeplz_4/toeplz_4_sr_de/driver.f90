PROGRAM codelet_driver
 USE varGlobales

 IMPLICIT NONE

 TYPE(PARAM),DIMENSION(1) :: tabdata
 integer :: align_up
 integer :: record_num, repeat_value, i, m, n, align, aligned_size
 character*80 :: paramfile
 character*80 :: record_tmp

! real*8, dimension (:), allocatable :: g
! real*8, dimension (:), allocatable :: h
 real*8, pointer :: gh(:), g(:), h(:), dummy
 real*8 pp, qq

 paramfile='codelet.data'
 record_tmp = '1'

 read(record_tmp,*)record_num
 CALL read_data_file (paramfile, tabdata, 1)

 repeat_value=tabdata(record_num)%repeat_value
 n=tabdata(record_num)%n
 m=1

! allocate(g(n))
! allocate(h(n))
 align=32

 aligned_size=align_up(n*sizeof(dummy), align)/sizeof(dummy)


! allocate(gh(2*n))
 allocate(gh(2*aligned_size))

! CALL getdmatrix (g, n, 1)
! CALL getdmatrix (h, n, 1)

!g = 0
!h = 0
gh = 0
g=>gh(1:n)
!h=>gh((n+1):(2*n))
h=>gh((aligned_size+1):(aligned_size+n))

 pp = real (3.14)
 qq = pp

  CALL measure_init()
  CALL measure_start()
 do i=1,repeat_value
	CALL codelet(n, g, h, pp, qq)
 end do
 CALL measure_stop()




! deallocate (g)
! deallocate (h)
 deallocate (gh)

END PROGRAM codelet_driver
