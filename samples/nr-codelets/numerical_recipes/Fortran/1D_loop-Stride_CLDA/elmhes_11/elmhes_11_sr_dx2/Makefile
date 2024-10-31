CF=ifort
CC=icc
FFLAGS=-g -O3 -xcore-avx2  -align array64byte
CFLAGS=-c
LDFLAGS=-g -lm
LIBS=-lmeasure
LIBPATH=../../../../codeletProbe
EXEC=wrapper

all: $(EXEC)

$(EXEC): cmodule.o codelet.o cutil.o getticks.o driver.o
	$(CF) -o $@ $^ $(LDFLAGS)  $(LIBS) -L$(LIBPATH)

getticks.o:
	$(CC) $(CFLAGS) getticks.c

codelet.s: codelet.f90
	$(CF) -o $@ -S $< $(FFLAGS)
#LOADS
#	delete 2,3,4th loads 
#	sed -i '/movups.*).*\,.*xmm[345]/d' $@
#	sed -i '/movsd.*xmm.*\,/d' $@
#       did not delete loading of g below
#	sed -i '/movsd.*).*\,.*xmm1/d' $@
#STORES
	sed -i -r 's/(.*movups).*(%xmm.*),(.*\(.*\))/\1 \3, \2/' $@
	sed -i -r 's/(.*movsd).*(%xmm.*),(.*\(.*\))/\1 \3, \2/' $@
	sed -i -r 's/(.*movhpd).*(%xmm.*),(.*\(.*\))/\1 \3, \2, \2/' $@
	sed -i -r 's/(.*movups).*(%ymm.*),(.*\(.*\))/\1 \3, \2/' $@
	sed -i -r 's/(.*movsd).*(%ymm.*),(.*\(.*\))/\1 \3, \2/' $@
#       sed -i '/movss.*xmm.*\,.*(/d' $@
#	sed -i '/movsd.*xmm.*\,.*(/d' $@
#	sed -i '/movups.*xmm.*\,.*(/d' $@
#       sed -i '/movups.*xmm1.*[134].*(/d' $@
#	sed -i '/movhpd.*xmm.*\,.*(/d' $@
#OTHERS
#	sed -i 's/mulpd/mulsd/g' $@
#       sed -i 's/movups/movsd/g' $@
#       sed -i '/mulpd.*[345]/d' $@
#       sed -i -n 'p; /mulsd.*xmm1,/p;/mulsd.*xmm1,/p' $@


codelet.o: codelet.s
	$(CF) -o $@ -c $< $(FFLAGS)

%.o: %.f90
	$(CF) -o $@ -c $< $(FFLAGS)

clean:
	rm -rf *.o *.mod $(EXEC) codelet.s
