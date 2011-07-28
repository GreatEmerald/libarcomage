#!/bin/sh
# Script for rebuilding the D library on Linux.
# GreatEmerald, 2011
cd ../src
dmd -m64 -c -lib -fPIC ArcomageD.d
cp ArcomageD.a ../../lib/libArcomageD.a
rm ArcomageD.a
echo "Finished rebuilding the D library."
read
