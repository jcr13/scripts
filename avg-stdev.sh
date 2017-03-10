#!/bin/bash

workdir=`pwd`
pdbdir="$workdir/contacts_pdb_stats"
pdbs=$(ls $sumdir)

awk '{a[FNR]+=$4;sumsq[FNR]+=($4)^2} \
    END {for (i=1;i<=FNR;i++) { \
    printf "%.2f %.2f\n", \
    a[i]/(ARGC-1), \
    sqrt((sumsq[i]-a[i]^2/(ARGC-1))/(ARGC-2))} \
    }' $pdbdir/*
