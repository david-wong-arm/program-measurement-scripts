int codelet_ (int n, int, double a[__restrict n][n], int, double);
int codelet_(int n, int m, double a[__restrict n][n], int x, double g) {

    int y;
    int k; /* needed for matmul */
    for (y=0; y<n; y++) {
      for (x=0; x<n; x++) {
        a[y][x] = a[y][x] * g;
        a[y][x] = a[y][x] * g;
      }
    }
    return n*n;
}

