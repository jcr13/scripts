#!/bin/bash

CUTOFF_IN_MB=1
LOG=~/Compress.log
CHECKLOG=~/Compress-check.log
COMPRESS_FILES=1

while [[ ! -z $1 ]] ; do
  case "$1" in
    "--log"  ) shift ; LOG=$1 ;;
    "--cut"  ) shift ; CUTOFF_IN_MB=$1 ;;
    "--test" ) COMPRESS_FILES=0 ;;
    *        ) echo "Unknown option." ; exit 1 ;;
  esac
  shift
done

if [[ $COMPRESS_FILES -eq 0 ]] ; then
  echo "Just listing files that match the cutoff to log. No compression."
fi

SIZE_ARG="+"$CUTOFF_IN_MB"M"

echo "#`date`" >> $LOG
echo "#`pwd`" >> $LOG
echo "#Compressing files > $CUTOFF_IN_MB MB in size." >> $LOG

O_TOTAL=0
C_TOTAL=0
N=0
CHECK=0

for FILE in `find -L . -size $SIZE_ARG` ; do
  # Skip binary files and files that are symbolic links.
  if [[ -L $FILE ]] ; then
    continue
  fi
  if [[ `file $FILE | awk '{for (col=2; col <= NF; col++) { if (index($col,"data")!=0) {print "data"; exit 0;} }}'` != "data" ]] ; then
    FDATA=`ls -l $FILE`
    ORIGINAL_SIZE=`echo $FDATA | awk '{print $5}'`
    echo $FDATA
    echo $FDATA >> $LOG
    if [[ $COMPRESS_FILES -eq 1 ]] ; then
      # Does a compressed version already exist?
      if [[ -e $FILE".gz" ]] ; then
        echo "Warning: $FILE.gz already exists. Skipping."
        echo "$FILE" >> $CHECKLOG
        ((CHECK++))
        continue
      fi
      gzip $FILE
      if [[ $? -ne 0 ]] ; then
        echo "Compression failed." > /dev/stderr
        exit 1
      fi
      ((N++))
      CDATA=`ls -l $FILE.gz`
      COMP_SIZE=`echo $CDATA | awk '{print $5}'`
      # Size math
      O_TOTAL=`echo "$O_TOTAL + ($ORIGINAL_SIZE / (1024*1024))" | bc -l`
      C_TOTAL=`echo "$C_TOTAL + ($COMP_SIZE / (1024*1024))" | bc -l`
    fi
  fi
done

echo "#Compressed $N files"
echo "#Compressed $N files" >> $LOG

if [[ $N -gt 0 ]] ; then
  printf "#Original size:   %.2f MB\n" $O_TOTAL
  printf "#Compressed size: %.2f MB\n" $C_TOTAL
  printf "#Original size:   %.2f MB\n" $O_TOTAL >> $LOG
  printf "#Compressed size: %.2f MB\n" $C_TOTAL >> $LOG

  RATIO=`echo "(1-($C_TOTAL / $O_TOTAL)) * 100.0" | bc -l`
  printf "#Files are %.2f %% smaller.\n" $RATIO 
  printf "#Files are %.2f %% smaller.\n" $RATIO >> $LOG 
fi
echo "" >> $LOG

if [[ $CHECK -gt 0 ]] ; then
  echo "Compressed versions of $CHECK files found (look at $CHECKLOG)."
fi
exit 0
