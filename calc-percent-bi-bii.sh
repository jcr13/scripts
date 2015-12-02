#!/bin/bash

rm percent-bi.1.dat
rm percent-bii.1.dat
rm percent-bi.2.dat
rm percent-bii.2.dat
rm percent-bi.3.dat
rm percent-bii.3.dat

#set variables for system and watson strand (BEGW to ENDW) and crick strand (BEGC to ENDC)
sys=1jj4
WORKDIR=/uufs/chpc.utah.edu/common/home/cheatham-group5/james/e2-dna
BEGW=1
ENDW=15
BEGC=17
ENDC=31

#calculate over 3 copies
for copy in 1 2 3
    do
        #calculate epsilon and zeta w/ cpptraj
        for i in $(eval echo "{$BEGW..$ENDW} {$BEGC..$ENDC}")
        do
        cpptraj -p $WORKDIR/$sys-analysis/nowat.$sys.hmr.prmtop << EOF > multidihedral.out
trajin $WORKDIR/$sys-analysis/$copy/${sys}_$copy.nc 1 100 1

multidihedral epze epsilon zeta resrange $i out epsi-zeta.$copy.$i.dat range360
run

hist epze[epsilon]:$i,0,360,1,* out epsi-hist.$copy.$i.dat
hist epze[zeta]:$i,0,360,1,* out zeta-hist.$copy.$i.dat
EOF
        done
    
        #take the difference, epsilon-zeta from mutlidihedral output
        for i in $(eval echo "{$BEGW..$ENDW} {$BEGC..$ENDC}")
        do
            sed 1d epsi-zeta.$copy.$i.dat | awk '{D=($2 - $3); print $1 "\t" D}' > diff.$copy.$i.dat
        done
        
        #if difference is negative, then Bi (0), else Bii (1)
        for i in $(eval echo "{$BEGW..$ENDW} {$BEGC..$ENDC}")
        do
            while read col1 col2;do
                if (( $(bc <<< "$col2 < 0") ))
                then
                    echo 0
                elif (( $(bc <<< "$col2 > 0") ))
                then
                    echo 1
                fi
            done < diff.$copy.$i.dat > bi.$copy.$i.dat
        done
        
        #calculate percent bi and bii then direct to files
        for i in $(eval echo "{$BEGW..$ENDW} {$BEGC..$ENDC}")
        do
            totlines=$(wc -l bi.$copy.$i.dat | awk '{print $1}')
            totbi=$(grep -c 0 bi.$copy.$i.dat)
            tmppercentbi=$(echo "($totbi/$totlines)*100" | bc -l)
            percentbi=$(printf "%.1f" $tmppercentbi)
            echo Percent BI step $i: $percentbi
            totbii=$(grep -c 1 bi.$copy.$i.dat)
            tmppercentbii=$(echo "($totbii/$totlines)*100" | bc -l)
            percentbii=$(printf "%.1f" $tmppercentbii)
            echo Percent BII step $i: $percentbii
            echo -e $i '\t' $percentbi >> percent-bi.$copy.dat
            echo -e $i '\t' $percentbii >> percent-bii.$copy.dat
        done
done

rm diff.*.dat
rm bi.*.dat
