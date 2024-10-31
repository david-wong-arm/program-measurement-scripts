CC=gcc
CFLAGS=-c -I../common
LDFLAGS=-lm
EXEC=wrapper
LIBS=-lmeasure
# For now
LIBPATH=../../../cape-cls/utils/codeletProbe


all: util.o

%.o: %.s
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -rf *.o $(EXEC)
