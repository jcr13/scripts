#!/bin/bash

pep="$1"
old="$2"
new="$3"
wdir="$4"
nodes=1
ppn=12
let proc="$nodes"*"$ppn"

echo "#PBS -S /bin/tcsh
#PBS -l walltime=24:00:00,nodes=em512.ipoib:ppn="$ppn"
#PBS -A general-gpu
#PBS -N "$pep""$new" 
#PBS -e Lyp_"$new".err
#PBS -o Lyp_"$new".out
#PBS -M nadeem.vellore@utah.edu


source /uufs/chpc.utah.edu/common/home/u0794019/.tcshrc
source /uufs/chpc.utah.edu/common/home/u0794019/.aliases


#############################################
set old="$old"
set new="$new"

set wdir="$wdir"
set local=/scratch/ibrix/chpc_gen/u0794019/lyp/"$pep"/md_"$new"/
rm -fr \"\$local\"
mkdir -p \"\$local\"
cd \"\$local\"/

cp -f \"\$wdir\"/system.prmtop	\"\$local\"/
cp -f \"\$wdir\"/md_5ns.in		\"\$local\"/
cp \"\$wdir\"/md_\"\$old\"ns.rst		\"\$local\"/


# mpdboot -n 4 -f \"\$PBS_NODEFILE\"
# mpiexec -n 48 \"\$AMBERHOME\"/exe/pmemd.MPI -i md_5ns.in -o md_\"\$new\"ns.out -p system.prmtop -c md_\"\$old\"ns.rst -r md_\"\$new\"ns.rst -x md_\"\$new\"ns.nc -inf md_\"\$new\"ns.info


source /uufs/ember.arches/sys/pkg/mvapich2/1.7i/etc/mvapich2.csh

mpiexec -n 2 \"\$AMBERHOME\"/bin/pmemd.cuda.MPI    -i md_5ns.in -o md_\"\$new\"ns.out -p system.prmtop -c md_\"\$old\"ns.rst -r md_\"\$new\"ns.rst -x md_\"\$new\"ns.nc -inf md_\"\$new\"ns.info -l md_\"\$new\"ns.log

cp \"\$local\"/md_\"\$new\"ns.out 	\"\$wdir\"/
cp \"\$local\"/md_\"\$new\"ns.rst 	\"\$wdir\"/
cp \"\$local\"/md_\"\$new\"ns.nc 	\"\$wdir\"/
cp \"\$local\"/md_\"\$new\"ns.info  \"\$wdir\"/
cp \"\$local\"/md_\"\$new\"ns.log 	\"\$wdir\"/



"
