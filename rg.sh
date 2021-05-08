#!/bin/bash

#Program: Interview
#Author: Kendrick Ngo

#Delete some un-needed files
rm *.o
rm *.out
rm *.lis

echo "Compile main.cpp"
g++ -c -Wall -m64 -no-pie -o main.o main.cpp -std=c++17 -g

echo "Compile interview.asm"
nasm -f elf64 -l interview.lis -o interview.o interview.asm -g -gdwarf

echo "Link the object files"
g++ -m64 -no-pie -o interview.out -std=c++17 main.o interview.o -g

echo "Run the program assign4:"
gdb ./interview.out

echo "Delete some un-needed files"
rm *.o
rm *.lis

echo "The script file will terminate"
