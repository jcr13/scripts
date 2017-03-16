#!/bin/bash
#$ -R yes
#$ -V
#$ -cwd
#$ -N rms
#$ -j y
##$ -t 1-30
#$ -l highio=1
#$ -q cpu_short
#$ -P kenprj
#$ -m abe
#$ -M james.robertson@stonybrook.edu
set -x

# Set amberhome
export AMBERHOME="/home/alberto/amber_git/amber"
source $AMBERHOME/amber.sh
export cpptraj="$AMBERHOME/bin/cpptraj"

#P=$PWD
P=/cavern/jamesr/meld-analysis/1bdd/xcom

for sys in on_2
do
    cd $P/$sys
    RMSD=$P/$sys/rmsd
    mkdir $RMSD
    rsync -avu clust_linkage_sieve_eps_2 topol.top /cavern/jamesr/1BDD.pdb $TMPDIR
    cd $TMPDIR

    # rmsd
    for clust in 0 1 2 3 4
    do
$cpptraj << EOF 
parm topol.top
trajin clust_linkage_sieve_eps_2/unique.c$clust.pdb
 
reference 1BDD.pdb

rms reference @CA out rms_ref.$clust.dat
EOF

    done

    # copy back data
    rsync -avu rms_ref.*.dat $RMSD

done
