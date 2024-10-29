int codelet_ (int n, int, double a[__restrict n][n], int, double);
int codelet_(int n, int m, double a[__restrict n][n], int x, double g) {

    int y;
    int k; /* needed for matmul */
    for (y=0; y<n; y++) {
      for (x=0; x<n; x++) {
        a[y][x] = 0;
        for(k = 0; k < n; k++) {
          a[x][y] = a[x][y] + a[x][k]*a[k][y];
        }
      }
    }
    return n*n;
}

