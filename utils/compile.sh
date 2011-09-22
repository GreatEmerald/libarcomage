#!/bin/sh
cd ../src
#rdmd --chatty --build-only -w -wi -lib -L-llua -I../include/LuaD arco.d cards.d
dmd -m64 -c -lib -od../lib -oflibarcomage -version=clibrary -L-llua -I../include/LuaD arco.d cards.d ../include/LuaD/luad/*.d ../include/LuaD/luad/conversions/*.d ../include/LuaD/luad/c/*.d
