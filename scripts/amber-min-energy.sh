#!/bin/bash

for i in 1 2 3 4 5;
do grep ENERGY -A 1 mini$i.out | awk '{print $2'} | grep -v ENERGY > mini$i-energy.dat;
done
