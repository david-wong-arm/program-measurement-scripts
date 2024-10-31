CF=ifort
CC=icc
FFLAGS=-g -O3 -xcore-avx2 -no-vec -align array64byte
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
	sed -i -r 's/(.*movups).*(%xmm.*),(.*\(.*\))/\1 \3, \2/' $@
	sed -i -r 's/(.*movsd).*(%xmm.*),(.*\(.*\))/\1 \3, \2/' $@
	sed -i -r 's/(.*movss).*(%xmm.*),(.*\(.*\))/\1 \3, \2/' $@
#	sed -i '/movups.*xmm.*\,/d' $@
#	sed -i '/movsd.*xmm.*\,.*(/d' $@
#	sed -i '/movss.*xmm.*\,.*(/d' $@
#	sed -i '/movhpd.*xmm.*\,.*(/d' $@
#	sed -i 's/mulpd/mulsd/g' $@

codelet.o: codelet.s
	$(CF) -o $@ -c $< $(FFLAGS)

%.o: %.f90
	$(CF) -o $@ -c $< $(FFLAGS)

clean:
	rm -rf *.o *.mod $(EXEC) codelet.s
