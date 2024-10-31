CF=ifort
CC=icc
FFLAGS=-g -O3 -xcore-avx2 -align array64byte
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

codelet.o: codelet.s
	$(CF) -o $@ -c $< $(FFLAGS)

%.o: %.f90
	$(CF) -o $@ -c $< $(FFLAGS)

clean:
	rm -rf *.o *.mod $(EXEC) codelet.s
