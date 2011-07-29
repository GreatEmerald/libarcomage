CC=gcc
BIN=arcomage
BINSERVER=arcomage-server
CFLAGS=-m64

all: $(BIN) $(BINSERVER)

clean:
	rm -f minIni.o arco.o arcosrv.o common.o cards.o graphics.o input.o config.o sound.o BFont.o $(BIN) $(BINSERVER)

#GE: This line is used when linking. This is linking.
$(BIN): minIni.o arco.o common.o cards.o config.o
	$(CC) -static minIni.o arco.o common.o cards.o config.o -m64 `pkg-config --libs lua` -ldl -lrt ../lib/libArcomageD.a -lphobos2 -lpthread -o $(BIN)

#GE: Unsupported FIXME!
$(BINSERVER): minIni.o arcosrv.o network.o common.o cards.o
	$(CC) minIni.o arcosrv.o common.o cards.o network.o `pkg-config --libs sdl` -lSDL_net -o $(BINSERVER)

#GE: This line is repeated for each of the files. This is compilation.
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@ `pkg-config --cflags lua`
