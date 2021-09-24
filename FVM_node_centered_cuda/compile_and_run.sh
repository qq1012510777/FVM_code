#!/bin/bash
cd bin
rm -rf main 
cd ../build
rm -rf *
cmake ..
make
cd ..
cd bin
echo "-----------------"
./main
cd ..