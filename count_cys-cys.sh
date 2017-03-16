#!/bin/bash
# count occurrences of disulfide bonds from pdb4amber output
DATADIR=/cavern/jamesr/meld_successes-and-failures
WORKDIR=/cavern/jamesr/meld_successes-and-failures/reference-structures
SDIR=/cavern/jamesr/meld_successes-and-failures/reference-structures/successes
FDIR=/cavern/jamesr/meld_successes-and-failures/reference-structures/failures
slist=`cat $DATADIR/pdb-list_successes.txt`
flist=`cat $DATADIR/pdb-list_failures.txt`
sc11list=`cat $DATADIR/casp11-list_successes.txt`
fc11list=`cat $DATADIR/casp11-list_failures.txt`
fc12list=`cat $DATADIR/casp12-list_failures.txt`
spdbs=$(echo $slist)
fpdbs=$(echo $flist)
sc11s=$(echo $sc11list)
fc11s=$(echo $fc11list)
fc12s=$(echo $fc12list)
# meld successes
for sys in $spdbs $sc11s
do
    cd $SDIR
    bond=$(tac $sys.out |grep Summary -m 1 -B 9999 |tac|grep "S-S"|wc|awk '{print $1}')
    if [ "$bond" -gt "0" ];
    then echo "####" 
        echo $sys
        echo $bond
    else continue
    fi
done
# meld failures
for sys in $fpdbs $fc11s $fc12s
do
    cd $FDIR
    bond=$(tac $sys.out |grep Summary -m 1 -B 9999 |tac|grep "S-S"|wc|awk '{print $1}')
    if [ "$bond" -gt "0" ];
    then echo "####" 
        echo $sys
        echo $bond
    else continue
    fi
done
