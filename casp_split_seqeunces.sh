#!/bin/bash
# CASP sequence files were downloaded from predictioncenter.org/download_area/CASPx/sequences
# casp1-7 sequence files were already split to individual files

# split file by newline and input text to individual tmp files
awk -v RS= '{print > ("tmp-" NR ".txt")}' CASP8/casp8.seq.txt CASP9/casp9.seq.txt CASP10/casp10.seq.txt CASP11/casp11.seq.txt CASP12/casp12.seq.txt

# rename tmp files to casp target id
for f in ./tmp-*.txt
do 
    SYS=$(head -1 $f| cut -c 2-6)
    cp $f $SYS.seq
    rm $f
    mv $SYS.seq CASP_ALL/
done
