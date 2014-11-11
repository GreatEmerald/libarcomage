# GEm: The main CMake file to build the shared library.
# GEm: Usage: cd to build/ and execute `cmake ..`

cmake_minimum_required(VERSION 2.8)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ 
# is checked
SET (CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

# Using Phobos
SET(CMAKE_D_USE_PHOBOS True)

# check for DDoc usage
INCLUDE(UseDDoc)

#################################
# Project
##############

PROJECT (libarcomage D)

# GEm: Add LuaD
# GEm: These are the files we need (from LuaD Makefile)
# GEm: They can't be in include/ itself due to scope issues
SET (LUAD_SOURCES
  luad/all.d
  luad/base.d
  luad/dynamic.d
  luad/error.d
  luad/lfunction.d
  luad/lmodule.d
  luad/stack.d
  luad/state.d
  luad/table.d
  luad/testing.d
  luad/c/all.d
  luad/c/lauxlib.d
  luad/c/lua.d
  luad/c/luaconf.d
  luad/c/lualib.d
  luad/c/tostring.d
  luad/conversions/arrays.d
  luad/conversions/assocarrays.d
  luad/conversions/classes.d
  luad/conversions/functions.d
  luad/conversions/structs.d
  luad/conversions/variant.d
)
# GEm: Hopefully it's in a subdirectory called include/LuaD (change if you need to)
SET (LUAD_PATH include/LuaD CACHE PATH "Path to the LuaD root directory")
# GEm: Get a full path
foreach (luad_src ${LUAD_SOURCES})
  list (APPEND LUAD_FILE_PATHS "${CMAKE_SOURCE_DIR}/${LUAD_PATH}/${luad_src}")
endforeach()

# GEm: Continue processing
ADD_SUBDIRECTORY (src)
