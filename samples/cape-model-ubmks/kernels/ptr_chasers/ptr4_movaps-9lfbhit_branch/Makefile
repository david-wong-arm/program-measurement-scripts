CC=gcc
CFLAGS=-c -I../common
LDFLAGS=-lm
EXEC=wrapper
LIBS=-lmeasure
# For now
LIBPATH=../../../cape-cls/utils/codeletProbe


all: $(EXEC)

$(EXEC): codelet.o driver.o codelet1.o ../common/util.o
	$(CC) -o $@ $^ $(LDFLAGS) $(LIBS) -L$(LIBPATH)

%.o: %.s
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -rf *.o $(EXEC)
