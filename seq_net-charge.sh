#!/bin/bash

WORKDIR=/cavern/jamesr/microproteins/sys_20aa-70aa

for sys in $WORKDIR/*
do
    ARG=$(awk '{print $1,gsub(/R/,"")}' $sys/sequence.dat | awk '{print $2}')
    LYS=$(awk '{print $1,gsub(/K/,"")}' $sys/sequence.dat | awk '{print $2}')
    ASP=$(awk '{print $1,gsub(/D/,"")}' $sys/sequence.dat | awk '{print $2}')
    GLU=$(awk '{print $1,gsub(/E/,"")}' $sys/sequence.dat | awk '{print $2}')
    POS=$(echo "$ARG + $LYS" | bc -l)
    NEG=$(echo "-($ASP + $GLU)" | bc -l)
    NET=$(echo "$POS + $NEG" | bc -l)
    echo $NET
done

