CF=ifort
CC=icc
#FFLAGS=-g -O3 -xSSE4.2 -align array64byte
FFLAGS=-g -O3 -xSSE4.2  -align array64byte -qopenmp
CFLAGS=-c
LDFLAGS=-g -lm -qopenmp
LIBS=-lmeasure
LIBPATH=../../../../codeletProbe
EXEC=wrapper

all: $(EXEC)

$(EXEC): cmodule.o codelet.o cutil.o getticks.o driver.o
	$(CF) -o $@ $^ $(LDFLAGS)  $(LIBS) -L$(LIBPATH)

getticks.o:
	$(CC) $(CFLAGS) getticks.c

%.o: %.f90
	$(CF) -o $@ -c $< $(FFLAGS)

clean:
	rm -rf *.o *.mod $(EXEC)
