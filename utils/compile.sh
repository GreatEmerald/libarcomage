#!/bin/sh
cd ../src
#rdmd --chatty --build-only -w -wi -lib -L-llua -I../include/LuaD arco.d cards.d
dmd -m64 -c -fPIC -oflibarcomage.o -L-llua -I../include/LuaD *.d ../include/LuaD/luad/*.d ../include/LuaD/luad/conversions/*.d ../include/LuaD/luad/c/*.d
dmd -m64 -shared -defaultlib=libphobos2.so -oflibarcomage.so libarcomage.o
rm libarcomage.o
mv libarcomage.so ../lib
cd ../utils
