#
# CMakeD - CMake module for D Language
#
# Copyright (c) 2007, Selman Ulug <selman.ulug@gmail.com>
#                     Tim Burrell <tim.burrell@gmail.com>
#
# All rights reserved.
#
# See Copyright.txt for details.
#
# Modified from CMake 2.6.5 CMakeDetermineCCompiler.cmake
# See http://www.cmake.org/HTML/Copyright.html for details
#

# determine the compiler to use for D programs
# NOTE, a generator may set CMAKE_D_COMPILER before
# loading this file to force a compiler.
# use environment variable DC first if defined by user, next use 
# the cmake variable CMAKE_GENERATOR_D which can be defined by a generator
# as a default compiler

if(NOT CMAKE_D_COMPILER)

  # prefer the environment variable DC
  if($ENV{DC} MATCHES ".+")
    get_filename_component(CMAKE_D_COMPILER_INIT $ENV{DC} PROGRAM PROGRAM_ARGS CMAKE_D_FLAGS_ENV_INIT)
    if(CMAKE_D_FLAGS_ENV_INIT)
      set(CMAKE_D_COMPILER_ARG1 "${CMAKE_D_FLAGS_ENV_INIT}" CACHE STRING "First argument to D compiler")
    endif(CMAKE_D_FLAGS_ENV_INIT)
    if(EXISTS ${CMAKE_D_COMPILER_INIT})
    else(EXISTS ${CMAKE_D_COMPILER_INIT})
      MESSAGE(FATAL_ERROR "Could not find compiler set in environment variable C:\n$ENV{DC}.") 
    endif(EXISTS ${CMAKE_D_COMPILER_INIT})
  endif($ENV{DC} MATCHES ".+")

  # next try prefer the compiler specified by the generator
  IF(CMAKE_GENERATOR_D) 
    IF(NOT CMAKE_D_COMPILER_INIT)
      SET(CMAKE_D_COMPILER_INIT ${CMAKE_GENERATOR_D})
    ENDIF(NOT CMAKE_D_COMPILER_INIT)
  ENDIF(CMAKE_GENERATOR_D)

  # finally list compilers to try
  IF(CMAKE_D_COMPILER_INIT)
    SET(CMAKE_D_COMPILER_LIST ${CMAKE_D_COMPILER_INIT})
  ELSE(CMAKE_D_COMPILER_INIT)
    SET(CMAKE_D_COMPILER_LIST gdc dmd)  
  ENDIF(CMAKE_D_COMPILER_INIT)

  # Find the compiler.
  FIND_PROGRAM(CMAKE_D_COMPILER NAMES ${CMAKE_D_COMPILER_LIST} DOC "C compiler")
  IF(CMAKE_D_COMPILER_INIT AND NOT CMAKE_D_COMPILER)
    SET(CMAKE_D_COMPILER "${CMAKE_D_COMPILER_INIT}" CACHE FILEPATH "C compiler" FORCE)
  ENDIF(CMAKE_D_COMPILER_INIT AND NOT CMAKE_D_COMPILER)
ENDIF(NOT CMAKE_D_COMPILER)
mark_as_advanced(CMAKE_D_COMPILER)  
get_filename_component(COMPILER_LOCATION "${CMAKE_D_COMPILER}" PATH)

find_program(CMAKE_AR NAMES ar PATHS ${COMPILER_LOCATION} )

FIND_PROGRAM(CMAKE_RANLIB NAMES ranlib)
IF(NOT CMAKE_RANLIB)
   SET(CMAKE_RANLIB : CACHE INTERNAL "noop for ranlib")
ENDIF(NOT CMAKE_RANLIB)
MARK_AS_ADVANCED(CMAKE_RANLIB)

# do not test for GNU if the generator is visual studio
IF(${CMAKE_GENERATOR} MATCHES "Visual Studio")
  SET(CMAKE_COMPILER_IS_GDC_RUN 1)
ENDIF(${CMAKE_GENERATOR} MATCHES "Visual Studio") 


IF(NOT CMAKE_COMPILER_IS_GDC_RUN)
  # test to see if the d compiler is gdc
  SET(CMAKE_COMPILER_IS_GDC_RUN 1)
  IF("${CMAKE_D_COMPILER}" MATCHES ".*gdc.*" )
    SET(CMAKE_COMPILER_IS_GDC 1)
    FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
      "Determining if the D compiler is GDC succeeded with "
      "the following output:\n${CMAKE_D_COMPILER}\n\n")
    EXEC_PROGRAM(${CMAKE_D_COMPILER} ARGS "--version" OUTPUT_VARIABLE CMAKE_COMPILER_OUTPUT)
    IF("${CMAKE_COMPILER_OUTPUT}" MATCHES ".*mingw.*" )
      SET(CMAKE_COMPILER_IS_MINGW 1)
    ENDIF("${CMAKE_COMPILER_OUTPUT}" MATCHES ".*mingw.*" )
    IF("${CMAKE_COMPILER_OUTPUT}" MATCHES ".*THIS_IS_CYGWIN.*" )
      SET(CMAKE_COMPILER_IS_CYGWIN 1)
    ENDIF("${CMAKE_COMPILER_OUTPUT}" MATCHES ".*THIS_IS_CYGWIN.*" )
  ELSE("${CMAKE_D_COMPILER}" MATCHES ".*dmd.*" )
    SET(CMAKE_COMPILER_IS_DMD 1)
    FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
      "Determining if the D compiler is DMD succeeded with "
      "the following output:\n${CMAKE_D_COMPILER}\n\n")
  ENDIF("${CMAKE_D_COMPILER}" MATCHES ".*gdc.*" )
ENDIF(NOT CMAKE_COMPILER_IS_GDC_RUN)


# configure variables set in this file for fast reload later on
IF(EXISTS ${CMAKE_SOURCE_DIR}/cmake/Modules/CMakeDCompiler.cmake.in)
	CONFIGURE_FILE(${CMAKE_SOURCE_DIR}/cmake/Modules/CMakeDCompiler.cmake.in 
        "${CMAKE_PLATFORM_INFO_DIR}/CMakeDCompiler.cmake" IMMEDIATE)
ELSE(EXISTS ${CMAKE_SOURCE_DIR}/cmake/Modules/CMakeDCompiler.cmake.in)
	CONFIGURE_FILE(${CMAKE_ROOT}/Modules/CMakeDCompiler.cmake.in 
        "${CMAKE_PLATFORM_INFO_DIR}/CMakeDCompiler.cmake" IMMEDIATE)
ENDIF(EXISTS ${CMAKE_SOURCE_DIR}/cmake/Modules/CMakeDCompiler.cmake.in)

MARK_AS_ADVANCED(CMAKE_AR)
SET(CMAKE_D_COMPILER_ENV_VAR "DC")

