CF=ifort
CC=icc
FFLAGS=-g -O3 -xcore-avx2  -align array64byte
CFLAGS=-c
LDFLAGS=-g -lm
LIBS=-lmeasure
LIBPATH=../../../../nr-codelets/codeletProbe
EXEC=wrapper

all: $(EXEC)

$(EXEC): cmodule.o codelet.o cutil.o getticks.o driver.o
	$(CF) -o $@ $^ $(LDFLAGS)  $(LIBS) -L$(LIBPATH)

getticks.o:
	$(CC) $(CFLAGS) getticks.c

codelet.s: codelet.f90
	$(CF) -o $@ -S $< $(FFLAGS)
	patch codelet.s codelet.s.patch 
#	sed -i '/movups.*xmm.*\,/d' $@
	sed -i -r 's/(.*vmovups).*(%[xy]mm.*),(.*\(.*\))/\1 \3, \2/' $@
	sed -i -r 's/(.*vmovupd).*(%[xy]mm.*),(.*\(.*\))/\1 \3, \2/' $@
	sed -i -r 's/(.*vmovsd).*(%xmm.*),(.*\(.*\))/\1 \3, \2/' $@
#	sed -i '/movsd.*xmm.*\,/d' $@
#	sed -i 's/mulpd/mulsd/g' $@

codelet.o: codelet.s
	$(CF) -o $@ -c $< $(FFLAGS)

%.o: %.f90
	$(CF) -o $@ -c $< $(FFLAGS)

clean:
	rm -rf *.o *.mod $(EXEC) codelet.s
