#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
extern int n; 
extern int m; 
extern int o; 
extern double a[900 + 0][1100 + 0]; 
extern double b[900 + 0][1200 + 0]; 
extern double c[1200 + 0][1100 + 0]; 
extern int iii;
extern int jjj;
extern int kkk;
/*
extern double a[3][4]; 
extern double b[3][5]; 
extern double c[5][4]; 
*/

int codelet_() {

    int y;
    int k; 
    int x;
    for (y=0; y<n; y++) {
      for (x=0; x<m; x++) {
        a[y][x] = 0;
        for(k = 0; k < o; k++) {
          a[y][x] = a[y][x] + b[y][k]*c[k][x];
        }
      }
    }
    iii = y;
    jjj = x;
    kkk = k;
    return n*n;
}
