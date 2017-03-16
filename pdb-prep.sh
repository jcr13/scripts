#!/bin/bash
set -x
# script to download pdb files, extract the chain and model of interest, 
#   prep for amber leap w/ pdb4amber, then generate parm7 and rst7 files
#   with leap
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
# meld successes chain A
for sys in $spdbs
do
    cd $SDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ];
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "A" {print $0}' $sys.NMR.pdb > $sys.chainA.pdb && \
            pdb4amber -i $sys.chainA.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "A" {print $0}' $SYS.pdb > $sys.chainA.pdb && \
            pdb4amber -i $sys.chainA.pdb -o $sys.pdb -d -p -y > $sys.out 2>&1
        fi
    else wget https://files.rcsb.org/view/$SYS.pdb
        EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ]; 
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "A" {print $0}' $sys.NMR.pdb > $sys.chainA.pdb && \
            pdb4amber -i $sys.chainA.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "A" {print $0}' $SYS.pdb > $sys.chainA.pdb && \
            pdb4amber -i $sys.chainA.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        fi
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld successes special cases (NMR but with only 1 model)
for sys in 1bdd 1prb 2a3d 1hnr 1k5o 1gw3
do
    cd $SDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then awk '$1 == "ATOM" && $5 == "A" {print $0}' $SYS.pdb > $sys.chainA.pdb && \
            pdb4amber -i $sys.chainA.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
    else wget https://files.rcsb.org/view/$SYS.pdb &&\
        awk '$1 == "ATOM" && $5 == "A" {print $0}' $SYS.pdb > $sys.chainA.pdb && \
        pdb4amber -i $sys.chainA.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld failures special cases (NMR but with only 1 model)
for sys in 1hnr 1k5o 1gw3
do
    cd $FDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then awk '$1 == "ATOM" && $5 == "A" {print $0}' $SYS.pdb > $sys.chainA.pdb && \
            pdb4amber -i $sys.chainA.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
    else wget https://files.rcsb.org/view/$SYS.pdb &&\
        awk '$1 == "ATOM" && $5 == "A" {print $0}' $SYS.pdb > $sys.chainA.pdb && \
        pdb4amber -i $sys.chainA.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld failures chain A
for sys in $fpdbs
do
    cd $FDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ];
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "A" {print $0}' $sys.NMR.pdb > $sys.chainA.pdb && \
            pdb4amber -i $sys.chainA.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "A" {print $0}' $SYS.pdb > $sys.chainA.pdb && \
            pdb4amber -i $sys.chainA.pdb -o $sys.pdb -d -p -y > $sys.out 2>&1
        fi
    else wget https://files.rcsb.org/view/$SYS.pdb
        EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ]; 
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "A" {print $0}' $sys.NMR.pdb > $sys.chainA.pdb && \
            pdb4amber -i $sys.chainA.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "A" {print $0}' $SYS.pdb > $sys.chainA.pdb && \
            pdb4amber -i $sys.chainA.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        fi
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld successes chain B
for sys in 1v74
do
    cd $SDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ];
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "B" {print $0}' $sys.NMR.pdb > $sys.chainB.pdb && \
            pdb4amber -i $sys.chainB.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "B" {print $0}' $SYS.pdb > $sys.chainB.pdb && \
            pdb4amber -i $sys.chainB.pdb -o $sys.pdb -d -p -y > $sys.out 2>&1
        fi
    else wget https://files.rcsb.org/view/$SYS.pdb
        EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ]; 
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "B" {print $0}' $sys.NMR.pdb > $sys.chainB.pdb && \
            pdb4amber -i $sys.chainB.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "B" {print $0}' $SYS.pdb > $sys.chainB.pdb && \
            pdb4amber -i $sys.chainB.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        fi
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld failures chain B
for sys in 1buh 1wqj
do
    cd $FDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ];
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "B" {print $0}' $sys.NMR.pdb > $sys.chainB.pdb && \
            pdb4amber -i $sys.chainB.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "B" {print $0}' $SYS.pdb > $sys.chainB.pdb && \
            pdb4amber -i $sys.chainB.pdb -o $sys.pdb -d -p -y > $sys.out 2>&1
        fi
    else wget https://files.rcsb.org/view/$SYS.pdb
        EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ]; 
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "B" {print $0}' $sys.NMR.pdb > $sys.chainB.pdb && \
            pdb4amber -i $sys.chainB.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "B" {print $0}' $SYS.pdb > $sys.chainB.pdb && \
            pdb4amber -i $sys.chainB.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        fi
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld failures chain C
for sys in 1eui 1ytf
do
    cd $FDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ];
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "C" {print $0}' $sys.NMR.pdb > $sys.chainC.pdb && \
            pdb4amber -i $sys.chainC.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "C" {print $0}' $SYS.pdb > $sys.chainC.pdb && \
            pdb4amber -i $sys.chainC.pdb -o $sys.pdb -d -p -y > $sys.out 2>&1
        fi
    else wget https://files.rcsb.org/view/$SYS.pdb
        EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ]; 
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "C" {print $0}' $sys.NMR.pdb > $sys.chainC.pdb && \
            pdb4amber -i $sys.chainC.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "C" {print $0}' $SYS.pdb > $sys.chainC.pdb && \
            pdb4amber -i $sys.chainC.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        fi
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld failures chain D
for sys in 1vrq
do
    cd $FDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ];
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "D" {print $0}' $sys.NMR.pdb > $sys.chainD.pdb && \
            pdb4amber -i $sys.chainD.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "D" {print $0}' $SYS.pdb > $sys.chainD.pdb && \
            pdb4amber -i $sys.chainD.pdb -o $sys.pdb -d -p -y > $sys.out 2>&1
        fi
    else wget https://files.rcsb.org/view/$SYS.pdb
        EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ]; 
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "D" {print $0}' $sys.NMR.pdb > $sys.chainD.pdb && \
            pdb4amber -i $sys.chainD.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "D" {print $0}' $SYS.pdb > $sys.chainD.pdb && \
            pdb4amber -i $sys.chainD.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        fi
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld failures chain I
for sys in 1smp 2sic
do
    cd $FDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ];
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "I" {print $0}' $sys.NMR.pdb > $sys.chainI.pdb && \
            pdb4amber -i $sys.chainI.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "I" {print $0}' $SYS.pdb > $sys.chainI.pdb && \
            pdb4amber -i $sys.chainI.pdb -o $sys.pdb -d -p -y > $sys.out 2>&1
        fi
    else wget https://files.rcsb.org/view/$SYS.pdb
        EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ]; 
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "I" {print $0}' $sys.NMR.pdb > $sys.chainI.pdb && \
            pdb4amber -i $sys.chainI.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "I" {print $0}' $SYS.pdb > $sys.chainI.pdb && \
            pdb4amber -i $sys.chainI.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        fi
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld failures chain R
for sys in 1fjg
do
    cd $FDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ];
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "R" {print $0}' $sys.NMR.pdb > $sys.chainR.pdb && \
            pdb4amber -i $sys.chainR.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "R" {print $0}' $SYS.pdb > $sys.chainR.pdb && \
            pdb4amber -i $sys.chainR.pdb -o $sys.pdb -d -p -y > $sys.out 2>&1
        fi
    else wget https://files.rcsb.org/view/$SYS.pdb
        EXP=$(grep EXPDTA $SYS.pdb | awk '{print $3}')
        if [ "$EXP" = "NMR" ]; 
        then pdb4amber -i $SYS.pdb -o $sys.NMR.pdb -d -p -y --model=1 >> $sys.NMR.out 2>&1 && \
            awk '$1 == "ATOM" && $5 == "R" {print $0}' $sys.NMR.pdb > $sys.chainR.pdb && \
            pdb4amber -i $sys.chainR.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        else awk '$1 == "ATOM" && $5 == "R" {print $0}' $SYS.pdb > $sys.chainR.pdb && \
            pdb4amber -i $sys.chainR.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
        fi
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld successes casp11
for sys in $sc11s
do
    cd $SDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y  >> $sys.out 2>&1
    else wget http://www.predictioncenter.org/casp11/TARGETS/$SYS.pdb &&\
        pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld failures casp11
for sys in $fc11s
do
    cd $FDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y  >> $sys.out 2>&1
    else wget http://www.predictioncenter.org/casp11/TARGETS/$SYS.pdb &&\
        pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld failures casp12
for sys in $fc12s
do
    cd $FDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y  >> $sys.out 2>&1
    else wget http://www.predictioncenter.org/casp12/TARGETS_PDB/$SYS.pdb &&\
        pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld failures casp12
for sys in t0874-d1 t0876-d1 t0882-d1 t0887-d1 t0890-d1 t0895-d1 t0915-d1 t0948-d1
do
    cd $FDIR
    SYS=$(echo "${sys^^}")
    ASYS=${SYS%???}
    if [ -f "$SYS.pdb" ];
    then pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y  >> $sys.out 2>&1
    else wget http://www.predictioncenter.org/casp12/MODELS_PDB/$SYS/"$ASYS"TS083_1-D1.pdb &&\
        mv "$ASYS"TS083_1-D1.pdb $SYS.pdb &&\
        pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld failures casp12
for sys in t0890-d2
do
    cd $FDIR
    SYS=$(echo "${sys^^}")
    ASYS=${SYS%???}
    if [ -f "$SYS.pdb" ];
    then pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y  >> $sys.out 2>&1
    else wget http://www.predictioncenter.org/casp12/MODELS_PDB/$SYS/"$ASYS"TS083_1-D2.pdb &&\
        mv "$ASYS"TS083_1-D2.pdb $SYS.pdb &&\
        pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
# meld failures casp12
for sys in t0890
do
    cd $FDIR
    SYS=$(echo "${sys^^}")
    if [ -f "$SYS.pdb" ];
    then pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y  >> $sys.out 2>&1
    else wget http://www.predictioncenter.org/casp12/MODELS_PDB/$SYS/"$SYS"TS083_1.pdb &&\
        mv "$SYS"TS083_1.pdb $SYS.pdb &&\
        pdb4amber -i $SYS.pdb -o $sys.pdb -d -p -y >> $sys.out 2>&1
    fi
    cat > leap.in<<EOF
source leaprc.protein.ff14SBonlysc
sys = loadpdb $sys.pdb
check sys
saveamberparm sys $sys.parm7 $sys.rst7
quit
EOF
    tleap -f leap.in > $sys.leap.log
done
