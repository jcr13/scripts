#!/bin/bash
# convert psipred output seq.horiz to ss.dat
# remove "Pred: ", remove newlines, redirect to ss.dat, then add newline to end of ss.dat

WORKDIR=/cavern/jamesr/microproteins/4746

for sys in $WORKDIR/*
do
    grep "Pred: " $sys/seq.horiz | cut -c 7- | tr -d '\n' > $sys/ss.dat
    sed -i -e '$a\' $sys/ss.dat
    sed -i 's/C/./g' $sys/ss.dat
done
