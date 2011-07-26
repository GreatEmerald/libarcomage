#!/bin/sh
# Script for recompiling the game and putting all the required files in their proper places.
# By GreatEmerald, 2011

echo "Attempting to recompile the game, please wait..."
cd ../src
make arcomage
#cp arcomage ../bin/linux-AMD64
make clean
echo "Finished compiling. Return to continue."
read
