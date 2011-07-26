CC=gcc
BIN=arcomage
BINSERVER=arcomage-server
CFLAGS=-m64

all: $(BIN) $(BINSERVER)

clean:
	rm -f minIni.o arco.o arcosrv.o common.o cards.o graphics.o input.o config.o network.o sound.o BFont.o $(BIN) $(BINSERVER)

#GE: This line is repeated when linking. This is linking.
$(BIN): minIni.o arco.o common.o cards.o config.o network.o
	$(CC) -shared minIni.o arco.o common.o cards.o config.o network.o -m64 `pkg-config --libs sdl` -lSDL_image -lSDL_net -lSDL_mixer `pkg-config --libs lua` -lrt ../lib/libArcomageD.a -lphobos2 -lpthread -o $(BIN)

#GE: Unsupported FIXME!
$(BINSERVER): minIni.o arcosrv.o network.o common.o cards.o
	$(CC) minIni.o arcosrv.o common.o cards.o network.o `pkg-config --libs sdl` -lSDL_net -o $(BINSERVER)

#GE: This line is repeated for each of the files. This is compilation.
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@ `pkg-config --cflags sdl` `pkg-config --cflags lua`
