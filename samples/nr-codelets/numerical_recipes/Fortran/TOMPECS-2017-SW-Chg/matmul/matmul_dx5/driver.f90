PROGRAM codelet_driver
 USE varGlobales

 IMPLICIT NONE

 TYPE(PARAM),DIMENSION(1) :: tabdata
 integer :: record_num, repeat_value, i,  n, i1
 character*80 :: paramfile
 character*80 :: record_tmp

 real*8, dimension (:, :), allocatable :: a, b, c
 real*8 :: f

 interface
   subroutine measure_sec_spin (nsec) bind(C, name="measure_sec_spin_")
     use ISO_C_BINDING 
     implicit none
     integer(C_INT), value :: nsec
   end subroutine measure_sec_spin
 end interface

 paramfile='codelet.data'
 record_tmp = '1'

 read(record_tmp,*)record_num
 CALL read_data_file (paramfile, tabdata, 1)

 repeat_value = tabdata(record_num)%repeat_value
 n = tabdata(record_num)%n
 !m = 20
 i1 = 1
 f = real (3)


 allocate(a(n, n))
 allocate(b(n, n))
 allocate(c(n, n))

! CALL getdmatrix (a, n, m)

a = 1
b = 0
do i=1,n
   b(i,i)=1
end do
c = 0

  CALL measure_init()
  CALL measure_sec_spin(15)
  CALL measure_start()
 do i=1,repeat_value
	CALL codelet(n, a, b, c)
 end do
 CALL measure_stop()

!do i=1,4
!  do i1=1,4
!    print *, c(i,i1)
!  end do
!end do



 deallocate (a)
 deallocate (b)
 deallocate (c)

END PROGRAM codelet_driver
