#!/bin/bash

echo "SYS   HEL   BET  SS"
for sys in 1pc0 1gyz 1rq6 1no1 1kaf 1hyw 1v74 1vaz 1vpu 1pyv 1qpm 1a6s 1emw 1iio 1nd9
do
    numH=$(awk '{print $1,gsub(/H/,"")}' ss_ref.$sys.dat | awk '{print $2}')
    numB=$(awk '{print $1,gsub(/E/,"")}' ss_ref.$sys.dat | awk '{print $2}')
    seqlen=$(awk '{print $1,gsub(/./,"")}' ss_ref.$sys.dat | awk '{print $2}')
    fracH=$(echo "$numH / $seqlen" | bc -l)
    fracB=$(echo "$numB / $seqlen" | bc -l)
    fracss=$(echo "($numB + $numH) / $seqlen" | bc -l)
    printf "%s %.2f %.2f %.2f\n" $sys $fracH $fracB $fracss
done

