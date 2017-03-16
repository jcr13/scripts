#!/bin/bash
#$ -R yes
#$ -V
#$ -cwd
#$ -N rgyr
#$ -j y
##$ -t 1-30
#$ -l highio=1
#$ -q cpu_short
#$ -P kenprj
#$ -m abe
#$ -M james.robertson@stonybrook.edu
set -x

# this works for extracting traj - is it enough for other analysis?
export PATH="/home/jamesr/anaconda2/envs/MELD/bin:$PATH"
source activate MELD

# Set amberhome
export AMBERHOME="/home/alberto/amber_git/amber"
source $AMBERHOME/amber.sh
export cpptraj="$AMBERHOME/bin/cpptraj"

SOURCEDIR="/cavern/jamesr/meld-analysis/1bdd/xcom"

for sys in on_1
do

    cd $SOURCEDIR/$sys
    RADS=$SOURCEDIR/$sys/radgyr
    mkdir $RADS

    # cp files
    rsync -avu extract_traj/trajectory.*.nc topol.top $TMPDIR
    #
    
    cd $TMPDIR

    # run radgyr and cp back
    END=9
    for i in $(seq 0 $END)
    do
    # ss 
$cpptraj << EOF 
parm topol.top
trajin trajectory.0$i.nc
radgyr out radgyr.0$i.dat
EOF

    done

    END=29
    for i in $(seq 10 $END)
    do
        # ss 
$cpptraj << EOF 
parm topol.top
trajin trajectory.$i.nc
radgyr out radgyr.$i.dat
EOF

    done
#

# copy back data
rsync -avu radgyr.*.dat $RADS

done
