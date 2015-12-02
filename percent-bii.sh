#!/bin/bash
#run as ./percent-bii.sh > percent-bii.dat

rm percent-bii.W.dat
rm percent-bii.C.dat

for i in {1..17}
do
    paste epsilonW.$i.1.dat zetaW.$i.1.dat > tmpW.$i.dat
    paste epsilonW.$i.2.dat zetaW.$i.2.dat >> tmpW.$i.dat
    paste epsilonW.$i.3.dat zetaW.$i.3.dat > tmpW.$i.dat
    awk '$2>210{print $1 "\t" $2 "\t" $3 "\t" $4}' tmpW.$i.dat > tmpW.$i.2.dat
    awk '$2<300{print $1 "\t" $2 "\t" $3 "\t" $4}' tmpW.$i.2.dat > tmpW.$i.3.dat
    awk '$4>150{print $1 "\t" $2 "\t" $3 "\t" $4}' tmpW.$i.3.dat > tmpW.$i.4.dat
    awk '$4<210{print $1 "\t" $2 "\t" $3 "\t" $4}' tmpW.$i.4.dat > tmpW.$i.5.dat
    numbii=$(wc tmpW.$i.5.dat | awk '{print $1}')
    numtot=$(wc tmpW.$i.dat | awk '{print $1}')
    fracbii=$(echo "scale=2; $numbii/$numtot*100" | bc -l)
    echo "step W $i fraction bii is $fracbii"
    echo "$fracbii" >> percent-bii.W.dat
done

for i in {2..18}
do
    paste epsilonC.$i.1.dat zetaC.$i.1.dat > tmpC.$i.dat
    paste epsilonC.$i.2.dat zetaC.$i.2.dat >> tmpC.$i.dat
    paste epsilonC.$i.3.dat zetaC.$i.3.dat > tmpC.$i.dat
    awk '$2>210{print $1 "\t" $2 "\t" $3 "\t" $4}' tmpC.$i.dat > tmpC.$i.2.dat
    awk '$2<300{print $1 "\t" $2 "\t" $3 "\t" $4}' tmpC.$i.2.dat > tmpC.$i.3.dat
    awk '$4>150{print $1 "\t" $2 "\t" $3 "\t" $4}' tmpC.$i.3.dat > tmpC.$i.4.dat
    awk '$4<210{print $1 "\t" $2 "\t" $3 "\t" $4}' tmpC.$i.4.dat > tmpC.$i.5.dat
    numbii=$(wc tmpC.$i.5.dat | awk '{print $1}')
    numtot=$(wc tmpC.$i.dat | awk '{print $1}')
    fracbii=$(echo "scale=2; $numbii/$numtot*100" | bc -l)
    echo "step C $i fraction bii is $fracbii"
    echo "$fracbii" >> percent-bii.C.dat
done

rm tmpW*dat
rm tmpC*dat
