CC=icc
# Following Fortran version to use lower opt level and -no-vec
CFLAGS=-c -g -std=c99 -O1 -no-vec -xSSE4.2
LDFLAGS=-g -lm
EXEC=wrapper
LIBS=-lmeasure
# For now
LIBPATH=../../../../nr-codelets/codeletProbe

all: $(EXEC)

$(EXEC): codelet.o driver.o
	$(CC) -o $@ $^ $(LDFLAGS) $(LIBS) -L$(LIBPATH)

driver.o: driver.c
	$(CC) -g -o $@ $< -c -O0

%.o: %.s %.c
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -rf *.o $(EXEC)
