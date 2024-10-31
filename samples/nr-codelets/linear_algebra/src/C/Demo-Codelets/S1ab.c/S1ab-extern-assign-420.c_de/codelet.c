#include "defs.h"

extern int n; 
extern double a[N + 0][N + 0]; 
extern double b[N + 0][N + 0]; 
extern int iii;
extern int jjj;
extern double g;

int codelet_() {

    int y;
    int k; /* needed for matmul */
    int x;
    for (y=0; y<n; y++) {
      for (x=0; x<n; x++) {
        a[y][x] = b[y][x] * g;
      }
    }
    iii = y;
    jjj = x;
    return n*n;
}

