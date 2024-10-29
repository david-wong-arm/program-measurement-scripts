CC=gcc
CFLAGS=-c
LDFLAGS=-lm
EXEC=wrapper
LIBS=-lmeasure
# For now
LIBPATH=../../../../nr-codelets/codeletProbe


all: $(EXEC)

$(EXEC): codelet.o driver.o
	$(CC) -o $@ $^ $(LDFLAGS) $(LIBS) -L$(LIBPATH)

%.o: %.s
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -rf *.o $(EXEC)
