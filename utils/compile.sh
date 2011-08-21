#!/bin/sh
cd ../src
rdmd --chatty --build-only -w -wi -lib -L-llua -I../include/LuaD arco.d cards.d
