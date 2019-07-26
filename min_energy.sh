#!/bin/bash

for i in 1 2 3 4;do

    awk '/ENERGY/{getline; print $2 }' step$i.system.out > energy$i.dat
done
