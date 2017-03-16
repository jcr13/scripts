#! /bin/bash
#$ -S /bin/bash
#$ -R yes
#$ -V
#$ -cwd
#$ -N Extract
#$ -j y
#$ -t 1-5
##$ -l  highio=1
#$ -l hostname=!(node05*|node06*)
##$ -q cpu_short@node001,cpu_short@node002,cpu_short@node003,cpu_short@node004,cpu_short@node005,cpu_short@node006,cpu_short@node007,cpu_short@node008,cpu_short@node009,cpu_short@node010,cpu_short@node011,cpu_short@node012,cpu_short@node013,cpu_short@node014,cpu_short@node015,cpu_short@node016,cpu_short@node017,cpu_short@node018,cpu_short@node019,cpu_short@node020,cpu_short@node021,cpu_short@node022
#$ -q cpu_short
#$ -P kenprj

P=$PWD
rsync -avu Data $TMPDIR
cd $TMPDIR

a=`perl -e 'print $ARGV[0]-1;' $SGE_TASK_ID`
b=`perl -e 'printf("%02i", $ARGV[0]-1);' $SGE_TASK_ID`
#echo $a
extract_trajectory extract_traj_dcd --replica $a trajectory.$b.dcd
extract_trajectory follow_dcd  --replica $a follow.$b.dcd

rsync -avu trajectory.$b.dcd follow.$b.dcd $P
