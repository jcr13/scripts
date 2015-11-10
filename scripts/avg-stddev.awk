#calculate average (A) and standard deviation (sqrt(v)) of a sample of three files and output xydy xmgrace format
#usage: ./avg-stddev.awk rmsf.1.dat rmsf.2.dat rmsf.3.dat > rmsf-xydy.dat
#where each rmsf file has xy data, the avg and stddev of y data is found, and the x, avg, and stddev are output in x y dy
paste $1 $2 $3 | sed '1d' | awk '{A=(($2+$4+$6)/3); x=$2-A; y=$4-A; z=$6-A; v=(((x^2)+(y^2)+(z^2))/2); print $1 "\t" A "\t" sqrt(v) }'
