#!/bin/bash

WORKDIR="/cavern/jamesr/meld_successes-and-failures"
successpdbs=$(awk '{print $1}' $WORKDIR/successes_pdb-list.txt)
failurepdbs=$(awk '{print $1}' $WORKDIR/failures_pdb-list.txt)

for a in $successpdbs
do
    cd $WORKDIR/fasta_successes
    wget http://www.rcsb.org/pdb/files/fasta.txt?structureIdList=$a
done

for a in $failurepdbs
do
    cd $WORKDIR/fasta_failures
    wget http://www.rcsb.org/pdb/files/fasta.txt?structureIdList=$a
done

