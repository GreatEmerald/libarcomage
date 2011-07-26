Arcomage Clone v0.4
Revision 2011.04.14, GreatEmerald

Arcomage Clone is, as the name implies, a clone of Arcomage. The goal of this
project is to recreate the standalone Arcomage to a feature parity, while
introducing new features to keep the game fresh and moddable.

=======
RUNNING
=======

In order to play the game, the user needs to do one of these things:

1) move the /data directory into the /bin/win32 or /bin/linux-AMD64 directories, or
2) move the contents of the /bin/win32 or /bin/linux-AMD64 directories to /, or
3) create a symbolic link that points from the /bin/<...> directory to the /data directory

and repeat the process for the directory 'lua' as well. I have included the
symlinks for Linux users, so they don't have to worry about that. Windows users
will have to create a junction or w/e to achieve the same effect. Note that this
behaviour will be changed into a configuration option later on.

If you are using Linux, you will have to install libsdl1.2, libsdl-image,
libsdl1.2-mixer, libsdl1.2-net and liblua5.1 to run the game (or their
equivalents in your Linux distribution; see the building section for hints).

After that, simply run bin/win32/Arcomage.exe or bin/linux-AMD64/arcomage and enjoy!

========
BUILDING
========

Building Arcomage Clone is actully a pretty complex procedure that involves
downloading a few extra programs that you wouldn't normally use for your every
day C compiling needs. Unlike with many of other developers, I do not believe
that people who are trying to build the game from source are know-it-alls, so
I will explain why you need the extra tools as well.
First off, the short form of what you need to build, depending on the operating
system:

Windows:
  Mandatory:
    DMC (Digital Mars C/C++ compiler): http://www.digitalmars.com/download/freecompiler.html
  Highly recommended:
    DMD (Digital Mars D compiler): http://www.digitalmars.com/d/download.html
  Recommended:
    DMC Basic Utilities: http://www.digitalmars.com/download/freecompiler.html
    DMC COFFImpLib: http://ftp.digitalmars.com/coffimplib.zip

NOTE: You cannot compile this project with MinGW or Visual C++ of any version.
Explanation is given below.

Linux:
  Mandatory:
    GCC 4.4+ (GNU Compiler Collection; gcc, gcc-4.4 or gcc-4.5)
    GNU Make (make)
    Embedded GNU C Library (libc6)
    SDL 1.2 (Simple DirectMedia Layer, 1.2.14; libsdl1.2-dev on Debian and
      libSDL-devel on openSUSE)
    SDL image (libsdl-image-dev on Debian and libSDL_image-devel on openSUSE)
    SDL mixer (libsdl-mixer-dev on Debian and libSDL_mixer-devel on openSUSE)
    SDL net (libsdl-net-dev on Debian and libSDL_net-devel on openSUSE)
    Lua 5.1 (liblua5.1-dev on Debian and lua-devel on openSUSE)
  Highly recommended:
    DMD 2.052+ (Digital Mars D compiler): http://www.digitalmars.com/d/download.html

NOTE: GDC was not tested with this project. It seems to be a little outdated,
but it might work as well.

Firstly I want to explain the system here, and what led to requirements like
that. You will have to delve a bit to the history of the project, so bear with
me.
You might ask why this project was written in C in the first place, instead of
something more recent such as C++. That was probably because of Linux
compatibility - the Linux kernel is written purely in C, thus Linux handles it
really well. And the original creator of this program, STiCK, is in fact a
developer of openSUSE (incidentally my distribution of choice), so he must have
had a lot of experience with C. For more information about this you'd have to
ask STiCK himself.
After a few versions of the game, I joined the project and basically took it
over from there. However, my background is quite a lot different. I am primarily
an UnrealScript coder (in case you're wondering, UnrealScript is the programming
language of Unreal Engine games, which is a mix of C++ and Java). So to me, C
felt and still feels archaic. I never had to use pointers in UnrealScript, and
I never needed it, so why should I care about them here? And without doing all
kinds of archaic tricks, you can't make a lot of things in C, and that includes
dynamic arrays (for example, if you want to use a different amount of cards than
it's set by default, you need dynamic arrays, period).
You might ask, what is my programming language of choice, then? Well, being
familiar with UnrealScript, after looking into quite a few of different
languages I have found that D is the most fitting one for me, because all the
methods and the syntax is familiar to me.

So that's why I am using D in this project - it handles everything that C can't,
such as dynamic arrays and string manipulation. And that's why I highly
recommend you to download DMD for both Windows and Linux. It will allow you to
recompile the D part of the game, which would be inaccessible without it.

Now you might wonder why you can't compile this with any well-known compiler on
Windows, such as MinGW and VC++. It also has to do with D, or, rather,
Microsoft. The static libraries that the D compiler produces is in the OMF
(Object Module Format), which is an open format with well-defined
specifications. However, basically every other compiler out there uses COFF
(Common Object File Format), a format by Microsoft, which is poorly defined and
prone to changes depending on VC++ (case in point: the format changed when
MS released VC++ 6). Since COFF is a lot more popular, all compilers use that.
But they don't recognise OMF, thus you can't use them. Thankfully, DMC, the C
compiler made by the same company that created D, uses OMF as well, and so can
do the job just as well.
Linux doesn't have such a problem, however, because it uses different library
formats altogether, which are open and thus cause no such conflicts. That's why
you can simply use GCC for compiling the code there.

OMF/COFF issue is also why the tools are recommended there. Basic Tools have
ImpLib, which is used for building OMF .lib files from DLLs (note: for some
insane reason, when using ImpLib, the output file goes first. See more here:
http://www.digitalmars.com/ctg/implib.html). You wouldn't normally need this,
however, unless you wish to add more libraries to the project. COFFImpLib is a
different utility, and it's very useful - it converts COFF .lib files to OMF
.lib files. That's the usual thing that you'd want to do if you want to add a
library to the project. More info about it here:
http://www.digitalmars.com/ctg/coffimplib.html

Now about Linux. If you don't know why you need GCC, GNU Make and libc6, then,
uh, yeah. SDL is the part that is responsible for all the rendering, so it's
clearly required. SDL image can import PNGs, SDL mixer is responsible for audio,
SDL net - for network games (which are probably broken right now). Lua is
required for mod makers that can't be bothered to recompile the game and break
net compatibility/create version mismatches. DMD is again required for building
the D part of the code, if you don't need to change that, you can just use the
precompiled library instead. Note that for compiling in x86_64 environment, you
need DMD 2.052, which in turn requires recent versions of GCC and libc6.

Right now I only have the x86_64 (AMD64) libraries and binaries precompiled,
but if you need to, you should be able to compile in 32-bit environment as well.
In that case you'll have to change the src/Makefile to include -m32 instead of
-m64. And make sure you copy the binaries to a new directory and let me know :)

=========
STRUCTURE
=========

You probably noticed that the project has several directories. Here's the
projected directory tree:

  +-- bin
  |   +-- win32
  |   +-- linux-AMD64
  |-- COPYING.TXT
  +-- d
  |   +-- src
  |   +-- utils
  +-- data
  +-- include
  +-- lib
  +-- lua
  |   +-- Arcomage
  +-- old
  |-- README.TXT
  +-- src
  +-- utils

I will go through what each folder contains. First off, the bin folder contains
the binaries that are needed in order to run the game. That means that the
win32 folder has 32-bit .dll and .ini files, while the linux-AMD64 directory has
64-bit .so and .cfg and executable files.
Note to developers: remember to put new things in both folders.

COPYING.TXT is a text file that contains GPL licensing information.

d is the folder that contains the source code for the D part of the project.
d/src is where the actual sources are kept, while d/utils is where the utilities
that help build the D part are held (for example, .cmd and .sh files for quick
compilation).

data is the folder that contains resources for the program. At the moment they
are standalone, but might become integrated into a resource file later on. The
folder contains .wav, .ico and .png files for the players.

include contains the include header files for the libraries used by C. It's also
utterly useless for Linux users, because there includes are provided in the
library packages themselves.

lib contains the needed static libraries for compiling the project. The static
libary created from the D source code also goes in here. Again, Linux users only
need the D library from here.

lua contains the Lua scripts for the game. They control the card decks and the
AI of the enemy, and are needed to run the game. lua/Arcomage contains the
information about the stock Arcomage deck.

old is a directory for obsolete files that could still be useful as a reference.
At the moment it includes the Windows Makefile version (obsolete since DMC
doesn't use those) and COFF format libraries (again obsolete since DMC doesn't
use those).

README.TXT is this file, in case you haven't noticed :)

src is the C source code. That's the crucial (and the most interesting) part of
the project. So far, at least.

utils, much like d/utils, contains utilities for building the code. The
utilities will probably interface with the ones from d/utils for easy
recompilation of the whole project, and will also have the standalone C
compilation utilities in case you don't want to use DMD.

