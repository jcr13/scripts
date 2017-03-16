#!/bin/bash
# Script that gives all values for the amount of information gained by making a
#   contact vs being connected in the backbone. E.g. if residue 10 and residue 
#   1 are connected (by some cutoff criteria), then they are 9 residues apart
#   in the backbone, but effectively only 1 residue apart. The general formula
#   that describes this is:
#   dij = (j - i) - 1
#The below script includes only dij for j - i > 3
#

N=50 # length of sequence

rm array.dat
touch array.dat

#echo "1 2 3 4 5 6 7 8 9 10" > array.dat
seqlen=$(seq 1 $N)
echo $seqlen > array.dat

for i in $(seq 1 $N)
do
    for j in $(seq $N -1 1)
    do
        if (( $(bc <<< "$j - $i > 3") ))
        then
            dij=$(echo "($j - $i) - 1" | bc -l)
            #echo $i $j
            #echo $dij
            (( array[i,j]=j - i - 1 ))
        else
            #echo 0
            (( array[i,j]= 0 ))
        fi
    done
    echo "$i ${array[*]}" >> array.dat
done

ONE=$(echo "$"1)
#gnuplot file is created. Plot with the command:j
#   gnuplot -p 'array.gnu'
# has to be gnuplot > 4.6
cat >array.gnu<<EOF
set cbrange[0:$N]
XTICS="`awk 'BEGIN{getline}{printf "%s ",$1}' array.dat`"
YTICS="`head -1 array.dat`"
set for [i=1:words(XTICS)] xtics ( word(XTICS,i) i-1 )
set for [i=1:words(YTICS)] ytics ( word(YTICS,i) i-1 )
plot "<awk '{$ONE=\"\"}1' array.dat | sed '1 d'" matrix w image
EOF
