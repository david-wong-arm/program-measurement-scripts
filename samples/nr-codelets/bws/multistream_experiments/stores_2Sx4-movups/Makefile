CC=gcc
CFLAGS=-c
LDFLAGS=-lm
EXEC=wrapper

all: $(EXEC)

$(EXEC): codelet.o driver.o
	$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.s
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -rf *.o $(EXEC)
