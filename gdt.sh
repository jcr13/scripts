#!/bin/bash

DIR=/cavern/jamesr/nonthreadable/meld_candidates/skolnick_nonthreadables/gang_of_32
GDT=/cavern/jamesr/nonthreadable/meld_candidates/skolnick_nonthreadables/gang_of_32/gdt
pdbs=$(cat ../41.list)

for sys in $pdbs;
    do
        for c in 0 1 2 3 4;
        do
            if [ -d "$sys" ]; then
                cd $GDT/$sys
                rm dist.dat
                rm percent.dat
                /home/jamesr/src/LGA_package/runlga.mol_mol.pl $DIR/$sys/"$sys"_native.pdb $DIR/$sys/clust_linkage/unique.c$c.pdb -3 -ie -o1 -sda -d:4.0
                dists="$(grep "GDT DIST_CUTOFF" RESULTS/"$sys"_native.pdb.unique.c$c.pdb.res | awk '{for(i=3;i<=22;++i)print $i}')"
                percent="$(grep "GDT PERCENT_AT" RESULTS/"$sys"_native.pdb.unique.c$c.pdb.res | awk '{for(i=3;i<=22;++i)print $i}')"
                for i in $dists;
                do
                    echo $i >> dist.dat
                done
                
                for j in $percent;
                do
                    echo $j >> percent.dat
                done
                paste percent.dat dist.dat > "$sys"_c"$c"_gdt.dat
                rm dist.dat
                rm percent.dat
            else
                mkdir $GDT/$sys
                cd $GDT/$sys
                rm dist.dat
                rm percent.dat
                /home/jamesr/src/LGA_package/runlga.mol_mol.pl $DIR/$sys/"$sys"_native.pdb $DIR/$sys/clust_linkage/unique.c$c.pdb -3 -ie -o1 -sda -d:4.0
                dists="$(grep "GDT DIST_CUTOFF" RESULTS/"$sys"_native.pdb.unique.c$c.pdb.res | awk '{for(i=3;i<=22;++i)print $i}')"
                percent="$(grep "GDT PERCENT_AT" RESULTS/"$sys"_native.pdb.unique.c$c.pdb.res | awk '{for(i=3;i<=22;++i)print $i}')"
                for i in $dists;
                do
                    echo $i >> dist.dat
                done
                
                for j in $percent;
                do
                    echo $j >> percent.dat
                done
                paste percent.dat dist.dat > "$sys"_c"$c"_gdt.dat
                rm dist.dat
                rm percent.dat
        fi
    done
done
