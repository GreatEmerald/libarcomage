#!/bin/sh
cd ../src
rdmd --build-only -lib arco.d cards.d -L-llua -I../include/LuaD -of../lib/libarcomage.a 
