#!/bin/bash
DATADIR=/cavern/jamesr/nonthreadable/meld_candidates
#pdblist=`cat $DATADIR/meld_candidates_nocyscys_orig.txt`
#pdblist=`cat $DATADIR/meld_candidates.txt`
#pdbs=$(echo $pdblist)
bar="#############"

#for sys in $pdbs
# unknown as of june 8
for sys in 1tm9 1bz4 1oxj 1ad6 1x9b 1vzs 1cl3 1yua 1mn8 1huf 1r8i 1o6w 1ywy 1wij 1eo0 1xs8 1q5z 1pbu
do
    rmsd0eps2=$(sed 1d $DATADIR/$sys/clust_linkage/2/rmsd-to-ref.0.dat | awk '{print $2}')
    rmsd1eps2=$(sed 1d $DATADIR/$sys/clust_linkage/2/rmsd-to-ref.1.dat | awk '{print $2}')
    rmsd2eps2=$(sed 1d $DATADIR/$sys/clust_linkage/2/rmsd-to-ref.2.dat | awk '{print $2}')
    rmsd3eps2=$(sed 1d $DATADIR/$sys/clust_linkage/2/rmsd-to-ref.3.dat | awk '{print $2}')
    rmsd4eps2=$(sed 1d $DATADIR/$sys/clust_linkage/2/rmsd-to-ref.4.dat | awk '{print $2}')
    #rmsd0eps4=$(sed 1d $DATADIR/$sys/clust_linkage/4/rms-to-ref.0.dat | awk '{print $2}')
    #rmsd1eps4=$(sed 1d $DATADIR/$sys/clust_linkage/4/rms-to-ref.1.dat | awk '{print $2}')
    #rmsd2eps4=$(sed 1d $DATADIR/$sys/clust_linkage/4/rms-to-ref.2.dat | awk '{print $2}')
    #rmsd3eps4=$(sed 1d $DATADIR/$sys/clust_linkage/4/rms-to-ref.3.dat | awk '{print $2}')
    #rmsd4eps4=$(sed 1d $DATADIR/$sys/clust_linkage/4/rms-to-ref.4.dat | awk '{print $2}')
    #rmsd0eps6=$(sed 1d $DATADIR/$sys/clust_linkage/6/rms-to-ref.0.dat | awk '{print $2}')
    #rmsd1eps6=$(sed 1d $DATADIR/$sys/clust_linkage/6/rms-to-ref.1.dat | awk '{print $2}')
    #rmsd2eps6=$(sed 1d $DATADIR/$sys/clust_linkage/6/rms-to-ref.2.dat | awk '{print $2}')
    #rmsd3eps6=$(sed 1d $DATADIR/$sys/clust_linkage/6/rms-to-ref.3.dat | awk '{print $2}')
    #rmsd4eps6=$(sed 1d $DATADIR/$sys/clust_linkage/6/rms-to-ref.4.dat | awk '{print $2}')
    #rmsd0eps8=$(sed 1d $DATADIR/$sys/clust_linkage/8/rms-to-ref.0.dat | awk '{print $2}')
    #rmsd1eps8=$(sed 1d $DATADIR/$sys/clust_linkage/8/rms-to-ref.1.dat | awk '{print $2}')
    #rmsd2eps8=$(sed 1d $DATADIR/$sys/clust_linkage/8/rms-to-ref.2.dat | awk '{print $2}')
    #rmsd3eps8=$(sed 1d $DATADIR/$sys/clust_linkage/8/rms-to-ref.3.dat | awk '{print $2}')
    #rmsd4eps8=$(sed 1d $DATADIR/$sys/clust_linkage/8/rms-to-ref.4.dat | awk '{print $2}')
    #rmsd0eps10=$(sed 1d $DATADIR/$sys/clust_linkage/10/rms-to-ref.0.dat | awk '{print $2}')
    #rmsd1eps10=$(sed 1d $DATADIR/$sys/clust_linkage/10/rms-to-ref.1.dat | awk '{print $2}')
    #rmsd2eps10=$(sed 1d $DATADIR/$sys/clust_linkage/10/rms-to-ref.2.dat | awk '{print $2}')
    #rmsd3eps10=$(sed 1d $DATADIR/$sys/clust_linkage/10/rms-to-ref.3.dat | awk '{print $2}')
    #rmsd4eps10=$(sed 1d $DATADIR/$sys/clust_linkage/10/rms-to-ref.4.dat | awk '{print $2}')

    var0eps2=$(printf "0\t%.2f\t" $rmsd0eps2)
    var1eps2=$(printf "1\t%.2f\t" $rmsd1eps2)
    var2eps2=$(printf "2\t%.2f\t" $rmsd2eps2)
    var3eps2=$(printf "3\t%.2f\t" $rmsd3eps2)
    var4eps2=$(printf "4\t%.2f\t" $rmsd4eps2)
    #var0eps4=$(printf "0\t%.2f\t" $rmsd0eps4)
    #var1eps4=$(printf "1\t%.2f\t" $rmsd1eps4)
    #var2eps4=$(printf "2\t%.2f\t" $rmsd2eps4)
    #var3eps4=$(printf "3\t%.2f\t" $rmsd3eps4)
    #var4eps4=$(printf "4\t%.2f\t" $rmsd4eps4)
    #var0eps6=$(printf "0\t%.2f\t" $rmsd0eps6)
    #var1eps6=$(printf "1\t%.2f\t" $rmsd1eps6)
    #var2eps6=$(printf "2\t%.2f\t" $rmsd2eps6)
    #var3eps6=$(printf "3\t%.2f\t" $rmsd3eps6)
    #var4eps6=$(printf "4\t%.2f\t" $rmsd4eps6)
    #var0eps8=$(printf "0\t%.2f\t" $rmsd0eps8)
    #var1eps8=$(printf "1\t%.2f\t" $rmsd1eps8)
    #var2eps8=$(printf "2\t%.2f\t" $rmsd2eps8)
    #var3eps8=$(printf "3\t%.2f\t" $rmsd3eps8)
    #var4eps8=$(printf "4\t%.2f\t" $rmsd4eps8)
    #var0eps10=$(printf "0\t%.2f\t" $rmsd0eps10)
    #var1eps10=$(printf "1\t%.2f\t" $rmsd1eps10)
    #var2eps10=$(printf "2\t%.2f\t" $rmsd2eps10)
    #var3eps10=$(printf "3\t%.2f\t" $rmsd3eps10)
    #var4eps10=$(printf "4\t%.2f\t" $rmsd4eps10)

    echo $bar
    echo $sys
    echo "Epsilon 2"
    echo $var0eps2
    echo $var1eps2 
    echo $var2eps2 
    echo $var3eps2 
    echo $var4eps2 
    #echo "Epsilon 4"
    #echo $var0eps4
    #echo $var1eps4
    #echo $var2eps4
    #echo $var3eps4
    #echo $var4eps4
    #echo "Epsilon 6"
    #echo $var0eps6
    #echo $var1eps6
    #echo $var2eps6
    #echo $var3eps6
    #echo $var4eps6
    #echo "Epsilon 8"
    #echo $var0eps8
    #echo $var1eps8
    #echo $var2eps8
    #echo $var3eps8
    #echo $var4eps8
    #echo "Epsilon 10"
    #echo $var0eps10
    #echo $var1eps10
    #echo $var2eps10
    #echo $var3eps10
    #echo $var4eps10
done
#done
