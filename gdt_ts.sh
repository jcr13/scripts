#!/bin/bash

D=`pwd`
CaspD='/cavern/CaspXIII/PostCasp/NMR_30replicas'
sys='N0968s2'
domain='N0968s2-D1'


# CASP reference
refDir='/cavern/CaspXIII/PostCasp/UnpublishedData'
ref='N0968s2-D1.pdb'

# Domain residue range
refRangeBegin='1'
refRangeEnd='115'
predRangeBegin='1'
predRangeEnd='115'

# Domain gaps (ok to leave empty)
refGapBegin=''
refGapEnd=''
predGapBegin=''
predGapEnd=''

# change to system directory
if [ ! -d $D/$domain ] 
then 
    mkdir $D/$domain && cd $D/$domain
else
    cd $D/$domain
fi

# rm gdt_ts.dat and print header
printf "%10s \t %5s \t %5s \t %5s \t %5s \t %5s \n" Domain c0 c1 c2 c3 c4 > gdt_ts.dat

# runlga
# runlga args def:
    # reference pdb
    # query pdb
    # -3 GDT and LCS analysis
    # -o0 no coordinates are printed out
    # -aa1:n1:n2 and -aa2:n1:n2 range of residues for analysis
    # -gap1 and -gap2 range of residues to remove from calculation
/home/frank/Software/LGA_package/runlga.mol_mol.pl $refDir/$ref $CaspD/$sys/Cpptraj_linkage_sieve_eps_2/unique.c0.pdb -3 -o0 -aa1:$refRangeBegin:$refRangeEnd -aa2:$predRangeBegin:$predRangeEnd -gap1:$refGapBegin:$refGapEnd -gap2:$refGapBegin:$refGapEnd 
/home/frank/Software/LGA_package/runlga.mol_mol.pl $refDir/$ref $CaspD/$sys/Cpptraj_linkage_sieve_eps_2/unique.c1.pdb -3 -o0 -aa1:$refRangeBegin:$refRangeEnd -aa2:$predRangeBegin:$predRangeEnd -gap1:$refGapBegin:$refGapEnd -gap2:$refGapBegin:$refGapEnd 
/home/frank/Software/LGA_package/runlga.mol_mol.pl $refDir/$ref $CaspD/$sys/Cpptraj_linkage_sieve_eps_2/unique.c2.pdb -3 -o0 -aa1:$refRangeBegin:$refRangeEnd -aa2:$predRangeBegin:$predRangeEnd -gap1:$refGapBegin:$refGapEnd -gap2:$refGapBegin:$refGapEnd 
/home/frank/Software/LGA_package/runlga.mol_mol.pl $refDir/$ref $CaspD/$sys/Cpptraj_linkage_sieve_eps_2/unique.c3.pdb -3 -o0 -aa1:$refRangeBegin:$refRangeEnd -aa2:$predRangeBegin:$predRangeEnd -gap1:$refGapBegin:$refGapEnd -gap2:$refGapBegin:$refGapEnd 
/home/frank/Software/LGA_package/runlga.mol_mol.pl $refDir/$ref $CaspD/$sys/Cpptraj_linkage_sieve_eps_2/unique.c4.pdb -3 -o0 -aa1:$refRangeBegin:$refRangeEnd -aa2:$predRangeBegin:$predRangeEnd -gap1:$refGapBegin:$refGapEnd -gap2:$refGapBegin:$refGapEnd 
GDT_TS_c0=$( grep -A 1 GDT_TS $D/$domain/RESULTS/$ref.unique.c0.pdb.res | sed 1d | awk '{print $7}' | xargs printf "%.2f \n" ) 
GDT_TS_c1=$( grep -A 1 GDT_TS $D/$domain/RESULTS/$ref.unique.c1.pdb.res | sed 1d | awk '{print $7}' | xargs printf "%.2f \n" ) 
GDT_TS_c2=$( grep -A 1 GDT_TS $D/$domain/RESULTS/$ref.unique.c2.pdb.res | sed 1d | awk '{print $7}' | xargs printf "%.2f \n" ) 
GDT_TS_c3=$( grep -A 1 GDT_TS $D/$domain/RESULTS/$ref.unique.c3.pdb.res | sed 1d | awk '{print $7}' | xargs printf "%.2f \n" ) 
GDT_TS_c4=$( grep -A 1 GDT_TS $D/$domain/RESULTS/$ref.unique.c4.pdb.res | sed 1d | awk '{print $7}' | xargs printf "%.2f \n" ) 
printf "%10s \t %5s \t %5s \t %5s \t %5s \t %5s \n" $domain $GDT_TS_c0 $GDT_TS_c1 $GDT_TS_c2 $GDT_TS_c3 $GDT_TS_c4 >> gdt_ts.dat
