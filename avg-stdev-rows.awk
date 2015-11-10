#use as: awk -f avg-stddev-rows.awk in1.dat in2.dat in3.dat...
{ if (FNR==1) file++
    for (i=1;i<=NF;i++) {
	sum[FNR" "i]+=$i
	count[FNR" "i]++
	data[file" "FNR" "i]=$i
    }
}END{
    for (i=1;i<=FNR;i++) {
	for (j=1;j<=NF;j++) {
	    avg[i" "j]=sum[i" "j]/count[i" "j]
	}
    }
    for (f=1;f<=file;f++) {
	for (i=1;i<=FNR;i++) {
	    for (j=1;j<=NF;j++) {
		tmp[i" "j]+=(data[f" "i" "j]-avg[i" "j])*(data[f" "i" "j]-avg[i" "j]);
	    }
	}
    }
    for (i=1;i<=FNR;i++) {
	for (j=1;j<=NF;j++) {
	    printf avg[i" "j]" "
	}
	for (j=1;j<=NF;j++) {
	    printf sqrt(tmp[i" "j]/count[i" "j])" "
	}
	printf "\n"
    }
}
