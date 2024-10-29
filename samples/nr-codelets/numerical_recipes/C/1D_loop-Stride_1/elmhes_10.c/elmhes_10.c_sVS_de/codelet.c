/*
SUBROUTINE codelet (n, m, a, y, m1, m2) ! m = 10, y = 3, m1 = 2, m2 = 10

integer n, m, m1, m2, j
real*8 a (n, m), y 
    
do j = 1, n
        a (j, m1) = a (j, m1) + y * a (j, m2)
end do 
END SUBROUTINE codelet

*/

int codelet_ (int n, int, double(*a)[n], double, int, int);
int codelet_(int n, int m, double (*a)[n], double y, int m1, int m2) {

    int j;
    for (j=0; j<n; j++) {
        a[m1][j]=a[m1][j] + y * a[m2][j];
    }
    return n;
}
