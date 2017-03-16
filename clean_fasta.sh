#!/bin/bash

WORKDIR="/cavern/jamesr/meld_successes-and-failures"
successpdbs=$(awk '{print $1}' $WORKDIR/successes_pdb-list.txt)
failurepdbs=$(awk '{print $1}' $WORKDIR/failures_pdb-list.txt)
failurecasps=$(awk '{print $1}' $WORKDIR/failures_caspid-list.txt)

# print cleaned fasta files for all successes
for a in $successpdbs
do
    SYS=$(echo "${a^^}")
    awk '/'"$SYS"':A/{a=1}/'"$SYS"':B/{a=0} a' $WORKDIR/fasta_successes/fasta.txt?structureIdList=$a \
        > $WORKDIR/fasta_successes/clean/fasta.txt?structureIdList=$a
done

# print cleaned fasta files for successes with not chain A
for a in 1v74
do
    SYS=$(echo "${a^^}")
    awk '/'"$SYS"':B/{a=1}/'"$SYS"':C/{a=0} a' $WORKDIR/fasta_successes/fasta.txt?structureIdList=$a \
        > $WORKDIR/fasta_successes/clean/fasta.txt?structureIdList=$a
done

# print cleaned fasta files for all failures of (fasta files)
for a in $failurepdbs
do
    SYS=$(echo "${a^^}")
    awk '/'"$SYS"':A/{a=1}/'"$SYS"':B/{a=0} a' $WORKDIR/fasta_failures/fasta.txt?structureIdList=$a \
        > $WORKDIR/fasta_failures/clean/fasta.txt?structureIdList=$a
done

# print cleaned fasta files for all failures with chain B of (fasta files)
for a in 1buh 1wqj 5j4a
do
    SYS=$(echo "${a^^}")
    awk '/'"$SYS"':B/{a=1}/'"$SYS"':C/{a=0} a' $WORKDIR/fasta_failures/fasta.txt?structureIdList=$a \
        > $WORKDIR/fasta_failures/clean/fasta.txt?structureIdList=$a
done

# print cleaned fasta files for all failures with chain C of (fasta files)
for a in 1eui 1ytf 5j5v
do
    SYS=$(echo "${a^^}")
    awk '/'"$SYS"':C/{a=1}/'"$SYS"':D/{a=0} a' $WORKDIR/fasta_failures/fasta.txt?structureIdList=$a \
        > $WORKDIR/fasta_failures/clean/fasta.txt?structureIdList=$a
done

# print cleaned fasta files for all failures with chain D of (fasta files)
for a in 1vrq
do
    SYS=$(echo "${a^^}")
    awk '/'"$SYS"':D/{a=1}/'"$SYS"':E/{a=0} a' $WORKDIR/fasta_failures/fasta.txt?structureIdList=$a \
        > $WORKDIR/fasta_failures/clean/fasta.txt?structureIdList=$a
done

# print cleaned fasta files for all failures with chain I of (fasta files)
for a in 1smp 2sic
do
    SYS=$(echo "${a^^}")
    awk '/'"$SYS"':I/{a=1}/'"$SYS"':J/{a=0} a' $WORKDIR/fasta_failures/fasta.txt?structureIdList=$a \
        > $WORKDIR/fasta_failures/clean/fasta.txt?structureIdList=$a
done

# print cleaned fasta files for all failures with chain R of (fasta files)
for a in 1fjg
do
    SYS=$(echo "${a^^}")
    awk '/'"$SYS"':R/{a=1}/'"$SYS"':S/{a=0} a' $WORKDIR/fasta_failures/fasta.txt?structureIdList=$a \
        > $WORKDIR/fasta_failures/clean/fasta.txt?structureIdList=$a
done

# print cleaned fasta files for all failures of (fasta files)
for a in $failurecasps
do
    SYS=$(echo "${a^^}")
    cp "$WORKDIR/fasta_failures/target.cgi?target=$SYS&view=sequence" $WORKDIR/fasta_failures/clean/fasta.txt?structureIdList=$a
done

