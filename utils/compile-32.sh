#!/bin/sh
cd ../src
#rdmd --chatty --build-only -w -wi -lib -L-llua -I../include/LuaD arco.d cards.d
dmd -m32 -c -lib -od../lib -oflibarcomage -version=clibrary -L-llua -I../include/LuaD *.d ../include/LuaD/luad/*.d ../include/LuaD/luad/conversions/*.d ../include/LuaD/luad/c/*.d
cd ../utils
