#!/bin/bash
# source /uufs/chpc.utah.edu/common/home/u0794019/.tcshrc


wdir=/uufs/chpc.utah.edu/common/home/u0794019/project/lyp/lyp_MD/lyp_r266a
cd "$dir"
last=35

for((job=1;job<11;job++))
do
	old=`echo "($job-1)*5+$last" | bc -l`
	new=`echo "$old+5"| bc -l`
	echo "$old" "$new"
	sh "$wdir"/submit_cuda.sh r266a "$old" "$new" "$wdir" > "$wdir"/submit_"$new".pbs
	echo " submitting "$wdir"/submit_"$new".pbs"
	if [ "$job" -eq 1 ]; then
	  	jobid=`qsub "$wdir"/submit_"$new".pbs`
	else
	   	jobid=`qsub -W depend=afterok:"$jobid" "$wdir"/submit_"$new".pbs`
	fi
done
