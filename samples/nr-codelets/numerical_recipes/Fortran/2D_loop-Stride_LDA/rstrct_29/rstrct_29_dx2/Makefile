CF=ifort
CC=icc
FFLAGS=-g -O3 -xcore-avx2 -align array64byte
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
# Below peel loop skiping is fine because the loop updates r11 and r12 which are being overwritten at 
# LN106 and LN108
	sed -i '/\.\.LN91:/a\\tjmp\t..B1.12' $@


codelet.o: codelet.s
	$(CF) -o $@ -c $< $(FFLAGS)


%.o: %.f90
	$(CF) -o $@ -c $< $(FFLAGS)

clean:
	rm -rf *.o *.mod $(EXEC) codelet.s
