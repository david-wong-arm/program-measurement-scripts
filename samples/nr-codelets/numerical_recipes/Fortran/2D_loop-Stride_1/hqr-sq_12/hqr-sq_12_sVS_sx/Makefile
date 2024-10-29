CF=ifort
CC=icc
FFLAGS=-g -O3 -xavx -no-vec -align array64byte
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

codelet.o: codelet.s
	$(CF) -o $@ -c $< $(FFLAGS)

%.o: %.f90
	$(CF) -o $@ -c $< $(FFLAGS)

clean:
	rm -rf *.o *.mod $(EXEC) codelet.s
