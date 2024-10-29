#set $args = ', '.join($vars)
SUBROUTINE codelet (n, m, $args, $fStride, g)

  integer n, m, k, $fStride, $fNonStride
  real*8 g
  #for $var in $vars
    #if $vartypes[$var] == 'A'
  real*8 $var (n, n)
    #else
  real*8 $var (n)
    #end if
  #end for

  do $fNonStride = 1, n
    do $fStride = 1, n
      #for $stmt in $stmts
      $stmt
      #end for
    end do
  end do

END SUBROUTINE codelet

