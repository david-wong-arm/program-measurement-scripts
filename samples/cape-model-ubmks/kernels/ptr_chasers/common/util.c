#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "util.h"

void buildAndCheckList(char* alignedMem, int nb_elements, int stride, int n, int shuffle) {
    struct item* cnt = (struct item*)alignedMem;
    int i;

#if 0
    for (i=0; i<n-1; i++) {
        cnt->next = cnt+1;
        /*
           if (i>n-10) {
           printf("%p, %ld\n", cnt, ((char*)cnt-alignedMem));
           }
         */
        cnt = cnt->next;
    }
    // printf("Done @ %p\n", cnt);
    cnt->next = (struct item*)alignedMem; // make it circular
    // printf("after write\n");
    cnt = (struct item*)alignedMem;
    // printf("last data = %d\n", cnt[n-1].data);
#endif

    // REDO TO CHECK init o/h
    unsigned long long *mapper = malloc(n*sizeof(unsigned long long));
    // set up identity mapping i-->i, so node ith is the data[i]
    for (i=0; i<nb_elements; i++) {
        int idx = i*stride;
        assert (idx < n);
        mapper[i] = idx;
    }
    if (shuffle) {
        // Now shuffle around the mapper array
        for (i=0; i<nb_elements; i++) {
            unsigned long long j = LRAND() % nb_elements;
            unsigned long long tmp = mapper[i];
            mapper[i] = mapper[j];
            mapper[j] = tmp;
        }

#if DEBUG 
        printf("SHUFFLED\n");
        for (i=0; i<nb_elements; i++) {
            printf("%lld ", mapper[i]);
        }
        printf("\n");
#endif
    }  /* end if (shuffle) */

//    memset (alignedMem, 0, alignedSize);
    struct item* head = (struct item*)alignedMem;
#if 0   /* Old implementation not using mapper[] */
    cnt = (struct item*)alignedMem;
    for (i=0; i<n-1; i++) {
        printf("%p->%p ", cnt, cnt+1);
        cnt->next = cnt+1;
        /*
           if (i>n-10) {
           printf("%p, %ld\n", cnt, ((char*)cnt-alignedMem));
           }
         */
        cnt = cnt->next;
    }
    printf("\n");
    // printf("Done @ %p\n", cnt);
    cnt->next = (struct item*)alignedMem; // make it circular
#else
    for (i=0; i<nb_elements-1; i++) {
        cnt = head+mapper[i];
        struct item* next = head+mapper[i+1];
        /* printf("%p->%p ", cnt, next); */
        cnt->next = next;
    }
    head[mapper[nb_elements-1]].next = head+mapper[0]; // make it circular
#endif
    /* Check all the array elements are visited when traversing the list n hops by checking the marked data. 
       This should implies all the visited are array elements: Suppose not, there exist 1 visited not array elements, 
       Then there will be <= n-1 elements visited (marked) */
    for (i=0; i<nb_elements; i++) {
        head[i*stride].data = 80386;
    }

    cnt = head;
    for (i=0; i<nb_elements; i++) {
        /* printf("%ld\n",cnt-head); */
        cnt->data = cnt->data + 1;
        cnt = cnt->next;
    }
    /* Check cirular list created correctly pointing to the first element */
    assert (cnt == head);  /* back to first element */
    /* Check all elements are visited */
    for (i=0; i<nb_elements; i++) {
        assert (head[i*stride].data == 80386+1);
    }
    /* if shuffle is not set, double check the list is sequential. */
    if (!shuffle) {
        for (i=0; i<nb_elements; i++) { 
            assert (head[i*stride].next == &head[((i+1)%nb_elements)*stride]);
        }
    }
    printf("All checks passed\n");

    free(mapper);
}

char* makeList(char* mem, int align, unsigned long long alignedSize, unsigned long long nb_elements, int shuffle) {
    char* alignedMem;
    unsigned long long i;

    // printf("alloc-->%p - %p, size=%d\n", mem, (mem+alignedSize+align), alignedSize+align);
    if (mem == NULL)
    {
        printf ("Could not allocate the main array.\n");
        return 0;
    }
    alignedMem = (char*) alignUp((unsigned long long)mem, align);

    //tab = (float*)(mem - (unsigned long long) mem % 32);
    //tab = tab + 8;  // 8 SP = 32 bytes

    unsigned long long n = nb_elements;
    //memset (tab, 0, n * sizeof(double));

    memset (alignedMem, 0, alignedSize);
    buildAndCheckList(alignedMem, n, 1, n, shuffle);

    return alignedMem;
    // printf("last data = %d\n", cnt[n-1].data);
    // REDO TO CHECK init o/h

}
unsigned long long alignUp(unsigned long long original, unsigned int align) {
    return (original +align - (original % align));
}


int read_arguments (unsigned long long* nb_elements, unsigned long long* inner_rep ,unsigned long long* repetitions, int* shuffle) {
    FILE* file; 
    file = fopen ("codelet.data", "r");

    if (file != NULL)
    {
        int res;

        res = fscanf (file, "%llu %llu %d", repetitions, inner_rep, shuffle);
        if (res != 3)
        {
            fclose (file);
            return -1;
        }
        //              (*nb_elements) = 26;  // hardcoded to be 26
        (*nb_elements) = (*inner_rep);
        if ((*inner_rep) < 1000) {
            (*inner_rep) = 1000;
        }

        fclose (file);

        return 0;
    }
    return -1;
}

char* initAlignMem(char* mem, int align, int alignedSize) {
    // printf("alloc-->%p - %p, size=%d\n", mem, (mem+alignedSize+align), alignedSize+align);
    char * alignedMem = (char*) alignUp((unsigned long long)mem, align);
    //memset (tab, 0, n * sizeof(double)); 
    memset (alignedMem, 0, alignedSize);
}

#if 0
/* Old implementatin below */
void makeStridedList0(char* alignedMem, int nb_elements, int stride, int n, int shuffle) {
            int i; 
            //tab = (float*)(mem - (unsigned long long) mem % 32);
            //tab = tab + 8;  // 8 SP = 32 bytes 
            //      int n = nb_elements;
            struct item* cnt = (struct item*)alignedMem;
            struct item* start = (struct item*)alignedMem;
            for (i=0; i<nb_elements-1; i++) {
                start[(i*stride)%n].next = &start[((i+1)*stride) % n];
                //      cnt->next = cnt+1;
                /*
                   if (i>n-10) {
                   printf("%p, %ld\n", cnt, ((char*)cnt-alignedMem));
                   }
                 */
                //      cnt = cnt->next;
            }
            cnt = &start[((nb_elements-1)*stride)%n];
            printf("Done @ %p\n", cnt);
            cnt->next = (struct item*)alignedMem; // make it circular.  Need this dispite of the % in loop
            // printf("after write\n");
            cnt = (struct item*)alignedMem;
            // printf("last data = %d\n", cnt[n-1].data);
}
#endif

void makeStridedList(char* alignedMem, int nb_elements, int stride, int n, int shuffle) {
    buildAndCheckList(alignedMem, nb_elements, stride, n, shuffle);
}
