#!/bin/bash

workdir=`pwd`
pdbdir="$workdir/contacts_pdb_stats"
pdbs=$(ls $sumdir)
col1=$(awk '{print $1}' $workdir/pair_list.dat)
col2=$(awk '{print $2}' $workdir/pair_list.dat)
avgstdev=$(awk '{a[FNR]+=$4;sumsq[FNR]+=($4)^2} \
    END {for (i=1;i<=FNR;i++) { \
    printf "%.2f %.2f\n", \
    a[i]/(ARGC-1), \
    sqrt((sumsq[i]-a[i]^2/(ARGC-1))/(ARGC-2))}
    }' $pdbdir/*)

awk '{a[FNR]+=$4;sumsq[FNR]+=($4)^2} \
    END {for (i=1;i<=FNR;i++) { \
    printf "%.2f %.2f\n", \
    a[i]/(ARGC-1), \
    sqrt((sumsq[i]-a[i]^2/(ARGC-1))/(ARGC-2))}
    }' $pdbdir/*
#outp=$(printf "%s %s %.2f\n" $col1 $col2 $avgstdev)
#outp=$(printf "%s" $avgstdev)

#echo $outp
#echo $avgstdev
