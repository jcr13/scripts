#!/bin/bash
#set variables for system and watson strand (BEGW to ENDW) and crick strand (BEGC to ENDC)
sys=ddd
WORKDIR=/uufs/chpc.utah.edu/common/home/cheatham-group1/james/ff-battles/nastruct
BEGW=3
ENDW=10
BEGC=15
ENDC=22

for ff in bsc0 bsc1 ez1ol4 ol15
do
    for wat in opc tip3p
    do
        cd $WORKDIR/$sys/$ff/$wat/percent-bii

        rm total.bi.dat
        rm total.bii.dat
        rm percent-bi.perbase.dat
        rm percent-bii.perbase.dat
        rm percent-bi.overall.dat
        rm percent-bii.overall.dat

        for i in $(eval echo "{$BEGW..$ENDW} {$BEGC..$ENDC}")
        do
            cpptraj -p $WORKDIR/$sys/$ff/$wat/vacuo.topo << EOF > $sys.$ff.$wat.bii.out
trajin $WORKDIR/$sys/$ff/$wat/aggregate.nc

check @N1,N2,P,OP1,OP2,C1',C2',C3',C4',O3',O4' skipbadframes silent

multidihedral epze epsilon zeta resrange $i range360
run

epzediff.$i.bi = epze[epsilon]:$i - epze[zeta]:$i 
run
filter epzediff.$i.bi min -360 max 0 name bi
run
writedata bi.$i.dat bi noxcol noheader


epzediff.$i.bii = epze[epsilon]:$i - epze[zeta]:$i 
run
filter epzediff.$i.bii min 0 max 360 name bii
run
writedata bii.$i.dat bii noxcol noheader
EOF
        done


        sleep 2

        for i in $(eval echo "{$BEGW..$ENDW} {$BEGC..$ENDC}")
        do
            totlines=$(wc -l bi.$i.dat | awk '{print $1}')
            totbi=$(grep -c 1 bi.$i.dat)
            tmppercentbi=$(echo "($totbi/$totlines)*100" | bc -l)
            percentbi=$(printf "%.1f" $tmppercentbi)
            echo Percent BI step $i: $percentbi
            totbii=$(grep -c 1 bii.$i.dat)
            tmppercentbii=$(echo "($totbii/$totlines)*100" | bc -l)
            percentbii=$(printf "%.1f" $tmppercentbii)
            echo Percent BII step $i: $percentbii
            echo -e $i '\t' $percentbi >> percent-bi.perbase.dat
            echo -e $i '\t' $percentbii >> percent-bii.perbase.dat
        done
         
        for i in $(eval echo "{$BEGW..$ENDW} {$BEGC..$ENDC}")
        do
            cat bi.$i.dat >> total.bi.dat
            cat bii.$i.dat >> total.bii.dat
        done

        totlines=$(wc -l total.bi.dat | awk '{print $1}')
        totbi=$(grep -c 1 total.bi.dat)
        tmppercentbi=$(echo "($totbi/$totlines)*100" | bc -l)
        percentbi=$(printf "%.1f" $tmppercentbi)
        echo Overall Percent BI: $percentbi
        totbii=$(grep -c 1 total.bii.dat)
        tmppercentbii=$(echo "($totbii/$totlines)*100" | bc -l)
        percentbii=$(printf "%.1f" $tmppercentbii)
        echo Overall Percent BII: $percentbii
        echo -e $percentbi > percent-bi.overall.dat
        echo -e $percentbii > percent-bii.overall.dat
    done
done
