# GEm: The main CMake file to build the shared library.
# GEm: Usage: cd to build/ and execute `cmake ..`

cmake_minimum_required(VERSION 3.0)

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ 
# is checked
SET (CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules)

# Using Phobos
SET(CMAKE_D_USE_PHOBOS True)

# GEm: Which files to generate documentation for
SET(CMAKE_D_BUILD_DOCS True CACHE BOOL "Whether to build documentation.")
SET(CMAKE_D_DDOC_MODULES "arco;cards;wrapper")
INCLUDE(UseDDoc)

# GEm: Make sure we allow setting the right lib[64] path
INCLUDE (GNUInstallDirs)

#################################
# Project
##############

PROJECT (libarcomage VERSION 0.2.0 LANGUAGES D)

SET (DYNAMIC_LINKING "YES" CACHE BOOL "Whether to link with LuaD dynamically or statically. Dynamic is default and recommended.")

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
find_path (LUAD_PATH luad/all.d
  PATHS ${CMAKE_SOURCE_DIR}/include/LuaD
  PATH_SUFFIXES dlang d dmd
  DOC "Path to the LuaD root directory")
if (NOT DYNAMIC_LINKING)
  # GEm: Get a full path
  foreach (luad_src ${LUAD_SOURCES})
    list (APPEND LUAD_FILE_PATHS "${LUAD_PATH}/${luad_src}")
  endforeach()
endif (NOT DYNAMIC_LINKING)

# GEm: Continue processing
ADD_SUBDIRECTORY (src)

# GEm: Install config and decks
INSTALL (DIRECTORY lua/ DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/arcomage/libarcomage)

# GEm: Install documentation
if (CMAKE_D_BUILD_DOCS)
  INSTALL (DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/documentation/ DESTINATION ${CMAKE_INSTALL_DOCDIR}/libarcomage)
endif (CMAKE_D_BUILD_DOCS)

# GEm: CPack specifics below. This can be openSUSE-specific, so other distros should use their own packaging.
SET (CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
SET (CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
SET (CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
SET (CPACK_PACKAGE_DESCRIPTION_SUMMARY "Backend for tower-building card games")
SET (CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/COPYING.TXT")
SET (CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.TXT")
SET (CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/DESCRIPTION.TXT")
# GEm: RPM specifics, this is definitely openSUSE-specific
SET (CPACK_RPM_PACKAGE_LICENSE "GPL-3.0+")
SET (CPACK_RPM_PACKAGE_GROUP "Amusements/Games")
INCLUDE (CPack)
