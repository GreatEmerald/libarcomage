@ECHO OFF
cd ../src
dmd -lib -I../include/LuaD -od../lib -ofarcomage ^
  arco.d cards.d wrapper.d ^
  ../include/LuaD/luad/all.d ^
  ../include/LuaD/luad/base.d ^
  ../include/LuaD/luad/c/all.d ^
  ../include/LuaD/luad/c/lua.d ^
  ../include/LuaD/luad/c/luaconf.d ^
  ../include/LuaD/luad/c/lauxlib.d ^
  ../include/LuaD/luad/c/lualib.d ^
  ../include/LuaD/luad/c/tostring.d ^
  ../include/LuaD/luad/stack.d ^
  ../include/LuaD/luad/table.d ^
  ../include/LuaD/luad/conversions/structs.d ^
  ../include/LuaD/luad/lfunction.d ^
  ../include/LuaD/luad/dynamic.d ^
  ../include/LuaD/luad/conversions/functions.d ^
  ../include/LuaD/luad/conversions/arrays.d ^
  ../include/LuaD/luad/conversions/assocarrays.d ^
  ../include/LuaD/luad/conversions/classes.d ^
  ../include/LuaD/luad/conversions/variant.d ^
  ../include/LuaD/luad/state.d ^
  ../include/LuaD/luad/error.d ^
  ../lib/lua51.lib
pause