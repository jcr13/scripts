#!/bin/bash
### set the number of processing elements (PEs) or cores
### set the number of PEs per node
#PBS -l nodes=30:ppn=16:xk
### set the wallclock time (will run at least minwclimit and max walltime
#PBS -l walltime=48:00:00
### If we set the job preemptee it may be killed. If the job is preemptee
### you get both bonus... let's see if we get killed often with preeemptee 
##PBS -l flags=preemptee
### set the job name
###PBS -N Gb91_80of109 
### set the job stdout and stderr
#PBS -e $PBS_JOBID.err
#PBS -o $PBS_JOBID.out
#PBS -q high
### set email notification
##PBS -M username@host
### In case of multiple allocations, select which one to charge
##PBS -A xyz

#cd in the dir you are when you submit the job 
cd $PBS_O_WORKDIR
module unload cudatoolkit/6.5.14-1.0502.9613.6.1
module load cudatoolkit/7.0.28-1.0502.10742.5.1
module swap gcc/4.8.2 gcc/4.9.3
source /mnt/b/projects/sciteam/gkg/Source/VirtualEnvs/OpenMM_GB/bin/activate
export OPENMM_DIR=/mnt/b/projects/sciteam/gkg/Source/OpenMM_GB/Bin_GB
export OPENMM_INCLUDE_PATH=$OPENMM_DIR/include
export OPENMM_LIB_PATH=$OPENMM_DIR/lib
export OPENMM_PLUGIN_DIR=$OPENMM_DIR/lib/plugins/
export LD_LIBRARY_PATH=$OPENMM_DIR/lib:$OPENMM_DIR/lib/plugins:$LD_LIBRARY_PATH
export OPENMM_CUDA_COMPILER=/opt/nvidia/cudatoolkit7.0/7.0.28-1.0502.10742.5.1/bin/nvcc
export AMBERHOME=/mnt/b/projects/sciteam/gkg/Source/amber
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$AMBERHOME/lib
export PATH=$AMBERHOME/bin:$PATH

if [ -e remd.log ]; then             #If there is a remd.log we are conitnuing a killed simulation
      prepare_restart --prepare-run  #so we need to prepare_restart
fi
aprun -n 30 -N 1 launch_remd --debug 
