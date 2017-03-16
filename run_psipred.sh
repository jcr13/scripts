echo ">SEQ" > seq.fa
cat sequence.dat >> seq.fa

/home/aperez/Source/psipred/runpsipred seq.fa

#/home/aperez/Source/hh-suite/build/bin/hhblits -i seq.fa  -d /home/aperez/Source/Databases/uniprot20_2015_06/uniprot20_2015_06 -oa3m sequence.a3m -cpu 8 -mact 0.35 -M 50 -e 1e-3 -n 3 -p 20 -Z 100 -z 1 -B 100 -seq 1 -aliw 80 -local -norealign -cov 0 
/home/aperez/Source/hh-suite/build/bin/hhblits -i seq.fa  -d /home/aperez/Source/Databases/uniprot20_2016_02/uniprot20_2016_02 -oa3m sequence.a3m -cpu 8 -mact 0.35 -M 50 -e 1e-3 -n 3 -p 20 -Z 100 -z 1 -B 100 -seq 1 -aliw 80 -local -norealign -cov 0 

#addss.pl sequence.a3m
#hhmake -i sequence.a3m
#hhsearch -i sequence.hhm -d ~justin/Database/HHSuite/pdb70_08Mar14_hhm_db

#/home/aperez/Source/hh-suite/scripts/reformat.pl  -uc sequence.a3m sequence.fasta  -M 25 -r 25
#/home/aperez/Source/CCMpred/scripts/convert_alignment.py sequence.fasta fasta sequence.aln
#/home/aperez/Source/CCMpred/bin/ccmpred -t 8 sequence.aln output.mat
#/home/aperez/Source/CCMpred/scripts/top_couplings.py -n 100 output.mat 

#is there an offset for the alignment?
#../ccm_validate.py  sequence.aln  distances_ccmpred.dat 4

#GREMLIN
#/home/aperez/Source/Gremlin/run_gremlin.sh MCR_PATH sequence.aln gremlin.dat
perl /home/aperez/Source/Gremlin/Scripts/seq_len.pl -i sequence.a3m -percent 25 1> results.seq 2> results.err
seq_len=`awk '{print $NF}' results.err`
div=`wc -c sequence.dat|awk '{print $1 - 1}'`

  MCRROOT="/home/aperez/Source/Matlab/v717"
  echo ---
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/runtime/glnxa64 ;
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/bin/glnxa64 ;
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRROOT}/sys/os/glnxa64;
    MCRJRE=${MCRROOT}/sys/java/jre/glnxa64/jre/lib/amd64 ;
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRJRE}/native_threads ; 
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRJRE}/server ;
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRJRE}/client ;
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCRJRE} ;  
  XAPPLRESDIR=${MCRROOT}/X11/app-defaults ;
  export LD_LIBRARY_PATH;
  export XAPPLRESDIR;
  echo LD_LIBRARY_PATH is ${LD_LIBRARY_PATH};

/home/aperez/Source/Gremlin/gremlin sequence.cut.msa        sequence.cut.apc verbose 1
perl /home/aperez/Source/Gremlin/Scripts/mtx2sco.pl -mtx sequence.cut.apc -cut sequence.cut -div $div -seq_len $seq_len -apcd sequence.cut.apcd > results.gremlin

# if need to visualize with respect to something
#../gremlin_validate.py results.gremlin > sequence.tcl 




