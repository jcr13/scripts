#!/bin/bash

for i in 05 1 2 3 4 5;
do grep Density eq$i.out | awk '{print $3}' > eq$i-density.dat;
done
