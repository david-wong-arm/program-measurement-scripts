int codelet_ (int n, int, double a[__restrict n][n], double b[__restrict n][n], double c[__restrict n][n], double d[__restrict n][n], int, double);
int codelet_(int n, int m, double a[__restrict n][n], double b[__restrict n][n], double c[__restrict n][n], double d[__restrict n][n], int x, double g) {

    int y;
    int k; /* needed for matmul */
    for (y=0; y<n; y++) {
      for (x=0; x<n; x++) {
        a[y][x] = b[y][x] * g;
        c[y][x] = d[y][x] * g;
      }
    }
    return n*n;
}

