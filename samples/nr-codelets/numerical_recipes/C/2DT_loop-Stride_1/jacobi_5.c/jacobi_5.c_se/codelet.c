#include <math.h>
// from original nrutil.h
static int imaxarg1,imaxarg2;
#define IMAX(a,b) (imaxarg1=(a),imaxarg2=(b),(imaxarg1) > (imaxarg2) ?\
                (imaxarg1) : (imaxarg2))
/*
SUBROUTINE codelet (n, a, res)
  integer n, ip, iq
  real*4 a (n, n), res (1), sm

  sm = res (1)

  do ip = 1, (n - 1 - 128)
     do iq = ip + 1, n
        sm = sm + abs (a (iq, ip))
     end do
  end do

  res (1) = sm;
 
END SUBROUTINE codelet
*/

int codelet_(int n, float (*a)[n], float *res);
int codelet_(int n, float (*a)[n], float *res) {
    int ip, iq;
    float sm;

    sm = *res;

    for (ip=1; ip<=n-1-128; ip++) {
        for (iq=ip+1; iq<=n; iq++) {
            sm = sm + fabs (a [ip-1][iq-1]);
        }
    }
    *res = sm;
    /* Non precise count */
    return (n-1-128)*n/2;
}
