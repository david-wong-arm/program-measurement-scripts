#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include "defs.h"

extern int n; 
extern int m; 
extern int o; 
extern double a[N + 0][M + 0]; 
extern double b[N + 0][O + 0]; 
extern double c[O + 0][M + 0]; 
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
    // essentailly n%4 ? 0: 4
    // if n is multiple of 4, no reduction of iterations, otherwise subtract by 4 and let remainder loop handle rest
    int yFringe = (n  % 1 == 0? n/1 : n / 1 + 1) % 4 == 0?0 : 4;
    for (y=0; y<n-yFringe; y+=4) {
      for (x=0; x<m; x++) {

        a[y][x] = 0;
        for(k = 0; k < o; k++) {
          a[y][x] = a[y][x] + b[y][k]*c[k][x];
        }

        a[y+1][x] = 0;
        for(k = 0; k < o; k++) {
          a[y+1][x] = a[y+1][x] + b[y+1][k]*c[k][x];
        }

        a[y+2][x] = 0;
        for(k = 0; k < o; k++) {
          a[y+2][x] = a[y+2][x] + b[y+2][k]*c[k][x];
        }

        a[y+3][x] = 0;
        for(k = 0; k < o; k++) {
          a[y+3][x] = a[y+3][x] + b[y+3][k]*c[k][x];
        }

      }
    }

    for (; y<n; y++) {
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
