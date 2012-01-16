Arcomage Clone Library (libarcomage) v0.1
Revision 2012.01.13, GreatEmerald

Arcomage Clone is, as the name implies, a clone of Arcomage. The goal of this
project is to recreate the standalone Arcomage to a feature parity, while
introducing new features to keep the game fresh and moddable.

This is the library of Arcomage, it is the essential part of the Arcomage Clone
project. It handles all of the internal game logic and configuration. The
library is licensed under the GNU GPLv3, see the COPYING.TXT file for more
information.

========
BUILDING
========

This library is written in the D programming language, so you will have to get
a D compiler (unless it's already provided by your distribution, but even then
you probably need another one). This library also depends on Lua for all of the
configuration needs.

Right now, this library is compiled as a static library due to the limitations
in the DMD compiler. The LLVM D compiler is capable of producing dynamic
libraries, but it does not work on Windows, so it's best to wait until either
DMD gains dynamic library support (it is a planned feature), or LDC gains proper
Windows support (which is less likely to happen).

First off, the short form of what you need to build, depending on the operating
system:

Windows:
  Mandatory:
    DMD (Digital Mars D compiler): http://www.digitalmars.com/d/download.html

Linux:
  Mandatory:
    DMD 2.052+ (Digital Mars D compiler): http://www.digitalmars.com/d/download.html
    GCC 4.4+ (GNU Compiler Collection; gcc, gcc-4.4 or gcc-4.5)
    Lua 5.1 (liblua5.1-dev on Debian and lua-devel on openSUSE)

NOTE: D compilers other than DMD were not tested, but might also work. GDC or
LLVM D compilers are sometimes included in Linux distributions by default, but
they were untested, so more likely than not don't work with this library.

You should make sure that with this source code file you also have the source
for LuaD (shown in the 'Structure' section below). If not, download the LuaD
sources manually and put them into the required place manually.

In order to build the static library, after installing the needed requirements,
open a terminal and navigate to the 'utils' directory. Then run './compile.sh'
on Linux or 'compile.cmd' on Windows.

=========
STRUCTURE
=========

This project includes several directories, whose use may not be obvious at first
glance, so I have provided an overview of the directory structure for the
library sources below.

  +-- include
  |   +-- LuaD
  +-- lib
  +-- lua
  |   +-- Arcomage
  |   +-- MArcomage
  +-- old
  |   +-- d
  |   +-- win32
  +-- src
  +-- utils
  |-- COPYING.TXT
  |-- CREDITS.TXT
  |-- README.TXT

include contains the source code of LuaD, which is a source library used by this
project. It is required on all platforms.

lib contains the precompiled libarcomage library and/or is the output location
for the library during the compilation process. This directory also includes
other static libraries, required by Windows in order to compile the library.
Linux users may ignore the other libraries there.

lua contains the Lua scripts for the game. They control the configuration,
manage installed card decks and contain the AI of the enemy, and thus are needed
to run the game. lua/Arcomage contains the information about the stock Arcomage
deck, while lua/MArcomage will contain information about cards used in the
MArcomage project.

old is a directory for obsolete files that could still be useful as a reference.
It should be of no concern for others and should not be included in the release
version of the library's source code.

src is the D source code. That's the crucial (and the most interesting) part of
the project, since the D code is at the core of the program and manages the
whole logic of the game, such as player statistics, card queue, executes actions
performed by cards etc.

utils contains utilities for building the code. Those are shell scripts for
quick compilation; you are free to change them in order to accomodate for your
specific machine architecture, setup etc. The scripts are there just for 
onvenience; the library may be compiled manually as well, although you would
have to make sure to include everything the library needs in the command.
Therefore it is always best to tweak the scripts here in case something doesn't
work.

COPYING.TXT is a text file that contains GPL licensing information.

CREDITS.TXT is a text file that notes people who have contributed or helped the
project in some way, as well as the libraries used by the project.

README.TXT is this file, in case you haven't noticed :)
