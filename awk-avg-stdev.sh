#awk '{for(i=1;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2}} END {for (i=1;i<=NF;i++) {print "%f %f \n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/(NR-1))}}'
#awk '{for(i=1;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2}} END {for (i=1;i<=NF;i++) {print "\n",sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/(NR-1))}}'
awk '{for(i=1;i<=NF;i++) {sum[i] += $i; sumsq[i] += ($i)^2}} END {for (i=1;i<=NF;i++) {print sum[i]/NR "\t" sqrt((sumsq[i]-sum[i]^2/NR)/(NR-1))}}'
