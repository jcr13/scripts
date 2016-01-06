#!/bin/bash
# Calculate percent BI/BII
# D. Roe 2016-01-06

SOURCEDIR=/uufs/chpc.utah.edu/common/home/cheatham-group1/james/ff-battles/nastruct
SYS=ddd
N_SEGMENTS=3
BEGW=3
ENDW=10
BEGC=15
ENDC=22
WORKDIR=`pwd`
INPUT=cpptraj.in
CPPTRAJ=`which cpptraj`
# If DEBUG is set to 1 no runs, only first script will be generated
DEBUG=0

for FF in bsc0 bsc1 ez1ol4 ol15 ; do
  for WAT in tip3p opc ; do
    cd $WORKDIR # Return us to the original working directory
    MYDIR=$SYS/$FF/$WAT/percent-bii
    if [[ ! -e $MYDIR ]] ; then
      mkdir -p $MYDIR
    fi
    cd $MYDIR
    # Set up files
    TOP=$SOURCEDIR/$SYS/$FF/$WAT/vacuo.topo
    CRD=$SOURCEDIR/$SYS/$FF/$WAT/aggregate.nc
    # Get total number of frames. Output of '-tl' is 'Frames: X'
    TOTAL_FRAMES=`$CPPTRAJ -p $TOP -y $CRD -tl | awk '{print $2;}'`
    if [[ -z $TOTAL_FRAMES || $TOTAL_FRAMES -lt 1 ]] ; then
      echo "Could not get number of frames." > /dev/stderr
      exit 1
    fi
    echo "  Trajectory has $TOTAL_FRAMES frames."
    # Divide roughly into N_SEGMENTS segments
    ((DIV1 = $TOTAL_FRAMES / $N_SEGMENTS))
    IDX=1
    for ((START=1; START < $TOTAL_FRAMES; START += $DIV1)) ; do
      if [[ $IDX -eq $N_SEGMENTS ]] ; then
        END="last"
      else
        ((END = $START + $DIV1 - 1))
      fi
      # Create output directory for segment
      OUTDIR="Segment$IDX"
      if [[ ! -e $OUTDIR ]] ; then
        mkdir $OUTDIR
      fi
      # Create cpptraj input for calculating dihedrals
      cat > $INPUT <<EOF
parm $SOURCEDIR/$SYS/$FF/$WAT/vacuo.topo
trajin $SOURCEDIR/$SYS/$FF/$WAT/aggregate.nc $START $END
check @N1,N2,P,OP1,OP2,C1',C2',C3',C4',O3',O4' skipbadframes silent
multidihedral EZ epsilon zeta resrange $BEGW-$ENDW,$BEGC-$ENDC \
              range360 out $OUTDIR/multidihedral.dat
run
EOF
      # Generate cpptraj input for calculating epsilon - zeta for each base,
      # as well as BI/BII (via 'datafilter') and percent BI/BII (via the
      # avg() function).
      for i in $(eval echo "{$BEGW..$ENDW} {$BEGC..$ENDC}") ; do
        cat >> $INPUT <<EOF

EZdiff.$i = EZ[epsilon]:$i - EZ[zeta]:$i
datafilter EZdiff.$i min -360 max 0 name BI.$i
PctBI.$i = avg(BI.$i)
datafilter EZdiff.$i min 0 max 360 name BII.$i
PctBII.$i = avg(BII.$i)
EOF
      done
    # Generate cpptraj input for calculating overall %BII
    cat >> $INPUT <<EOF

datafilter BII.* min 0 max 0 name overallPctBII
PctBIIoverall = avg(overallPctBII)
EOF
      # Write out raw BI and BII as well as percent BI and BII. Use the
      # 'invert' keyword for the latter so that the values are in a column
      # instead of a row.
      cat >> $INPUT <<EOF

writedata $OUTDIR/bi.dat BI.*
writedata $OUTDIR/bii.dat BII.*
writedata $OUTDIR/PctBi.dat invert PctBI.*
writedata $OUTDIR/PctBii.dat invert PctBII.*
writedata $OUTDIR/PctBii.overall.dat invert PctBIIoverall
EOF
      # Run cpptraj
      if [[ $DEBUG -ne 0 ]] ; then
        echo "DEBUG is set, only script for first segment is generated."
      else
        ($CPPTRAJ -i $INPUT 2>&1) | tee $OUTDIR/cpptraj.out
        if [[ $? -ne 0 ]] ; then
          echo "Cpptraj error." > /dev/stderr
          exit 1
        fi
      fi
      ((IDX++))
      if [[ $DEBUG -ne 0 ]] ; then
        break
      fi
    done # END loop over segments
  done # END loop over WAT
done # END loop over FF
exit 0
