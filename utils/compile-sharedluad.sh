#!/bin/sh
cd ../src
#rdmd --chatty --build-only -w -wi -lib -L-llua -I../include/LuaD arco.d cards.d
dmd -m64 -c -fPIC -oflibarcomage.o -L-llua -L-lluad -L-L../../LuaD/lib -I../include/LuaD *.d
dmd -m64 -shared -defaultlib=libphobos2.so -oflibarcomage.so libarcomage.o
rm libarcomage.o
mv libarcomage.so ../lib
cd ../utils
