#!/bin/bash

WORKDIR="/cavern/jamesr/nonthreadable/meld_candidates/hhpred_nonthreadable"
pdbs=$(awk '{print $1}' $WORKDIR/hhpred_nonthreadable.list)

rm $WORKDIR/tmp.list

for a in $pdbs
do
    LISTID=$(echo ${a:0-5:5}) # grab the first 5 chars (pdbid and chainid)
    CHAINID=$(echo ${LISTID:4:1}) # grab the 5th char (chain id)
    sys=$(echo ${LISTID:0-5:4}) # grab sys name (pdb id)
    SYS=$(echo "${sys^^}") # capitalize sys
    mkdir $WORKDIR/$LISTID
    cd $WORKDIR/$LISTID
    wget https://files.rcsb.org/view/$SYS.pdb
    #
    # if no chain ID provided
    if [ "$CHAINID" = "_" ]; then
        EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        CONFNUM=$(grep "CONFORMERS, NUMBER SUBMITTED" $SYS.pdb |awk '{print $7}')
        # if NMR structure w/ more than one conformer, take model 1
        if [ "$EXP" = "NMR" ] && [ "$CONFNUM" != "1" ]; then 
            pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y --model=1 >> $sys.out
            pdb2fasta.sh $sys.pdb > fasta.$SYS
            # if NMR structure w/ single conformer
        elif [ "$EXP" = "NMR" ] && [ "$CONFNUM" = "1" ]; then
            pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y >> $sys.out
            pdb2fasta.sh $sys.pdb > fasta.$SYS
            # if not NMR 
        else
            pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y >> $sys.out
            pdb2fasta.sh $sys.pdb > fasta.$SYS
        fi
    # if chain ID provided
    else
        EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        CONFNUM=$(grep "CONFORMERS, NUMBER SUBMITTED" $SYS.pdb |awk '{print $7}')
        # if NMR structure w/ more than one conformer, take model 1 with chainID
        if [ "$EXP" = "NMR" ] && [ "$CONFNUM" != "1" ]; then
            pdb4amber -i $SYS.pdb -o $sys.tmp.pdb -d -p -y --model=1 >> $sys.out
            #awk '$1 == "ATOM" && $5 == "'"$CHAINID"'" {print $0}' $sys.tmp.pdb > $sys.pdb
            awk '$1 == "ATOM" && $5 ~ /^'$CHAINID'/ {print $0}' $sys.tmp.pdb > $sys.pdb
            pdb2fasta.sh $sys.pdb > fasta.$SYS
            # if NMR structure w/ single conformer with chainID
        elif [ "$EXP" = "NMR" ] && [ "$CONFNUM" = "1" ]; then
            pdb4amber -i $SYS.pdb -o $sys.tmp.pdb -d -p -y >> $sys.out
            #awk '$1 == "ATOM" && $5 == "'"$CHAINID"'" {print $0}' $sys.tmp.pdb > $sys.pdb
            awk '$1 == "ATOM" && $5 ~ /^'$CHAINID'/ {print $0}' $sys.tmp.pdb > $sys.pdb
            pdb2fasta.sh $sys.pdb > fasta.$SYS
            # if not NMR, select chainID
        else 
            pdb4amber -i $SYS.pdb -o $sys.tmp.pdb -d -p -y >> $sys.out
            #awk '$1 == "ATOM" && $5 == "'"$CHAINID"'" {print $0}' $sys.tmp.pdb > $sys.pdb
            awk '$1 == "ATOM" && $5 ~ /^'$CHAINID'/ {print $0}' $sys.tmp.pdb > $sys.pdb
            pdb2fasta.sh $sys.pdb > fasta.$SYS
        fi
    fi
    seqlen=$(head -1 fasta.$SYS | awk '{print $6}')
    echo $LISTID $sys $seqlen >> $WORKDIR/tmp.list
done
