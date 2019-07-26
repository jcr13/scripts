#!/bin/bash
# calculate secondary structure assignments for native state reference structures
DATADIR=/cavern/jamesr/nonthreadable/meld_candidates/skolnick_nonthreadables/gang_of_32
pdbs=`cat $DATADIR/41.list`

for sys in $pdbs
do
    # get number of residues
    S=$(awk 'FNR == 8 {print $2}' $DATADIR/$sys/"$sys"_native.parm7 )

    # cpptraj calc secstruct
    cpptraj << EOF
parm $DATADIR/$sys/'$sys'_native.parm7
trajin $DATADIR/$sys/'$sys'_native.rst7
secstruct :1-$S assignout sse_ref.$sys.out
EOF

    # convert cpptraj out to meld-style ss.dat
    sed 's/ /./g' sse_ref.$sys.out > tmp1.dat
    sed '/^$/d' tmp1.dat > tmp2.dat
    sed 's/^.........//' tmp2.dat > tmp3.dat
    sed 's/\(.\{10\}\).\{1\}/\1/g' tmp3.dat > tmp4.dat
    sed -n '1~2!p' tmp4.dat > tmp5.dat
    sed ':a;N;$!ba;s/\n//g' tmp5.dat > tmp6.dat
    sed 's/B/E/g' tmp6.dat > tmp7.dat
    sed 's/[GITS]/./g' tmp7.dat > sse_ref.$sys.dat
    rm tmp*.dat
done
