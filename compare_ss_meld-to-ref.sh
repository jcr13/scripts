#!/bin/bash
#set -x

DATADIR=/cavern/jamesr/nonthreadable/meld_candidates
pdblist=`cat $DATADIR/meld_candidates_nocyscys_orig.txt`
#pdblist=`cat meld_candidates_nocyscys_orig.txt`
pdbs=$(echo $pdblist)

for sys in $pdbs
do

    meldss=$(cat $DATADIR/$sys/ss.dat)
    refss=$(cat ss_ref.$sys.dat)
    lenref=$(wc ss_ref.$sys.dat | awk '{print $3}')
    lenmeld=$(wc $DATADIR/$sys/ss.dat | awk '{print $3}')
    
    if [ $lenref == $lenmeld ]
    then
    
        for (( i=0; i<${#meldss}; i++ ))
        do
            seq1=${refss:$i:1}
            seq2=${meldss:$i:1}
            if [ $seq2 == $seq1 ]
            then 
                (( array[i]=0 ))
            else
                (( array[i]=1 ))
            fi
        done
        
        echo "${array[*]}" > array.$sys.dat
        unset array
        match=$(grep "0" -o array.$sys.dat > match.$sys.dat)
        countm=$(wc -l match.$sys.dat | awk '{print $1}')
        frac=$(echo "($countm / $lenref)" | bc -l)
        pfrac=$(printf "%.2f\n" $frac)
        echo "$sys $pfrac"

    else
        echo "$sys Lengths do not match"
    fi

done
