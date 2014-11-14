# GEm: Include LuaD directory, we need its headers for compilation
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_SOURCE_DIR}/${LUAD_PATH})

# GEm: List of owr own things to compile
SET (LIBARCOMAGE_SOURCES arco.d cards.d wrapper.d)

# GEm: Add our own sources and LuaD
add_library (arcomage SHARED ${LIBARCOMAGE_SOURCES} ${LUAD_FILE_PATHS})
set_target_properties (arcomage PROPERTIES VERSION ${PROJECT_VERSION})

# GEm: Tell the linker about Lua 5.1, needed for LuaD
find_package (FindLua51)
if (LUA51_FOUND)
  include_directories(${LUA_INCLUDE_DIR})
  target_link_libraries (arcomage ${LUA_LIBRARIES})
endif (LUA51_FOUND)

# GEm: Install the library
INSTALL (TARGETS arcomage LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
# GEm: Install include files (sources themselves)
INSTALL (FILES ${LIBARCOMAGE_SOURCES} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/arcomage)
