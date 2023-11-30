#!/usr/bin/env bash

mkdir -p bc
cd tests
cfiles=$(ls .)
for file in $cfiles; do
    prefix=${file:0:6}
    bc_file="$prefix.bc"
    /usr/local/llvm10ra/bin/clang -emit-llvm -c -O0 -g3 $file -o $bc_file
    /usr/local/llvm10ra/bin/llvm-dis $bc_file
done
cd ..
mv tests/*.bc bc
mv tests/*.ll bc
