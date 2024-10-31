CC=gcc
CFLAGS=-c -O2
LDFLAGS=-lm
EXEC=wrapper
LIBS=-lmeasure
# For now
LIBPATH=../../../../cape-cls/utils/codeletProbe


all: $(EXEC)

$(EXEC): driver.o kernel.o
	$(CC) -o $@ $^ $(LDFLAGS) $(LIBS) -L$(LIBPATH)

driver.o: ../../driver/3S.c
	$(CC) -o $@ $< $(CFLAGS)

kernel.o: kernel.c
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -rf *.o $(EXEC)
