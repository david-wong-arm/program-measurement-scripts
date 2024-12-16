CC=gcc
CFLAGS=-c -g -std=c99 -O3 -march=armv8.3-a
LDFLAGS=-g -lm
EXEC=wrapper
LIBS=-lmeasure
# For now
LIBPATH=../../../../../codeletProbe

all: $(EXEC)

$(EXEC): codelet.o driver.o
	$(CC) -o $@ $^ $(LDFLAGS) $(LIBS) -L$(LIBPATH)

driver.o: driver.c
	$(CC) -g -o $@ $< -c -O0

%.o: %.s %.c
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -rf *.o $(EXEC)
