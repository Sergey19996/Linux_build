@echo off

echo Configure start... :GENERATOR - Mingw Makefiles
cmake -S . -B out/build -G"MinGW Makefiles"
echo Configuration complete.
