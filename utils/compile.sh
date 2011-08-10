#!/bin/sh
cd ../src
rdmd --chatty --build-only -wi -lib -L-llua -I../include/LuaD arco.d cards.d
