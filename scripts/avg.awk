awk '{sum=0; for(i=1; i<=NF; i++){sum+=$i}; sum/=NF; print sum}'
