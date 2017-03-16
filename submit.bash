#!/bin/bash

script=$1
name=$2
njob=$3

echo I\'ll submit the script $script will restart $njob times with the name $name
echo If this is not what you want you have 10s to kill this process
echo The positional arguments are: PBS_script name number_of_restarts
#sleep 10


PID=$(qsub $script -N ${name}_0)
for i in `seq 1 $njob`; do
    PID=$(qsub $script -N ${name}_$i -W depend=afterany:$PID)
done


