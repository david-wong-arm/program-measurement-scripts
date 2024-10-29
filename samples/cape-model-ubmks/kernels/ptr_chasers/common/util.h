#ifndef _UTIL_H_
#define _UTIL_H_
#include <stdlib.h>
#include <inttypes.h>

#define LINE_SIZE 64
typedef uint64_t u64;

#define RAND() (rand() & 0x7fff)  /* ensure only 15-bits */
#define LRAND() (((u64)RAND()<<48) ^ ((u64)RAND()<<35) ^ ((u64)RAND()<<22) ^ ((u64)RAND()<< 9) ^ ((u64)RAND()>> 4))
struct item {
  struct item *next;
  unsigned long long data;
  char padding[LINE_SIZE-sizeof(struct item*)-sizeof(unsigned long long)];
};

char* makeList(char* mem, int align, unsigned long long alignedSize, unsigned long long nb_elements, int shuffle) ;
void makeStridedList(char* alignedMem, int nb_elements, int stride, int n, int shuffle) ;
unsigned long long alignUp(unsigned long long original, unsigned int align) ;

int read_arguments (unsigned long long* nb_elements, unsigned long long* inner_rep ,unsigned long long* repetitions, int* shuffle);

/*
 * Some old bmk uses this
 */
char* initAlignMem(char* mem, int align, int alignedSize) ;



#endif
