int codelet_ (int n, int, double a[__restrict n], double b[__restrict n][n], double c[__restrict n], int, double);
int codelet_(int n, int m, double a[__restrict n], double b[__restrict n][n], double c[__restrict n], int x, double g) {

    int y;
    int k; /* needed for matmul */
    for (y=0; y<n; y++) {
      for (x=0; x<n; x++) {
        a[y] = a[y] + b[y][x]*c[x];
      }
    }
    return n*n;
}

