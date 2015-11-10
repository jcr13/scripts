#!/bin/bash
set -x

#check that there are at least 3 spots available in backfill queue
showbf -f xk | grep nid11293 > xk.txt
filewc=$(cat xk.txt | wc | awk '{print $1}')
echo $filewc
if [ "$filewc" -lt "1" ];then
    echo There are less than 1 spots in backfill queue
    exit 0
else

#for i in 1 2 3;
for i in 1;
do
    showbf -f xk > xk.$i.txt
    t1=$(grep nid11293 xk.$i.txt | head -$i | tail -1 | awk '{print $4}')
    echo Walltime of $t1 is available
    t1h=${t1%%:*}
    t1h=$(printf "%.0f\n" $t1h)
    #check that available walltime is greater than 5 hours, or can be changed to whatever
    if [ "$t1h" -gt "5" ];then
        echo Walltime of $t1h is at least 5 hours
        #split the walltime and convert to seconds, then subtract 5 minutes and convert back to walltime format
        t1s=${t1##*:}
        t1m=${t1%:*}
        t1m=${t1m#*:}
        t1tis=$(($t1h * 3600 + t1m * 60 + t1s))
        fmin=300
        newt1is=$(($t1tis - $fmin))
        newt1h=$((newt1is/3600))
        newt1m=$(echo "($newt1is - (3600 * $newt1h))/60" | bc -l)
        var1=$(printf "%.0f\n" $newt1m)
        #make sure seconds of walltime have 2 digits
        newt1s="00"
        #make sure minutes of walltime have 2 digits, and print walltime
        if [ "`expr length "$var1"`" -gt "1" ];then
            walltime=$(printf "%.0f":"%.0f":"%s\n" $newt1h $newt1m $newt1s)
            echo New walltime is $walltime
        else
            walltime=$(printf "%.0f":0"%.0f":"%s\n" $newt1h $newt1m $newt1s)
            echo New walltime is $walltime
        fi
        #change timlin for clean exit, set to 30 mins (1800 s) less than new walltime (newt1is)
        newtimlimvar=$(($newt1is - 1800))
        newtimlim='timlim='$newtimlimvar''
        nodes=$(grep nid11293 xk.$i.txt | head -$i | tail -1 | awk '{print $3}')
        geometry=$(grep nid11293 xk.$i.txt | head -$i | tail -1 | awk '{print $7}')
        sed -e 's/WALLTIME/'$walltime'/g' sub.template > bff.$i.sub
        sed -i 's/NODES/'$nodes'/g' bff.$i.sub
        sed -i 's/GEOM/'$geometry'/g' bff.$i.sub
        sed -i 's/JOBNAME/bff.'$i'/g' bff.$i.sub
        sed -i 's/COPY/'$i'/g' bff.$i.sub
        sed -i 's/MDIN/md.'$i'.in/g' bff.$i.sub
        sed 's/timlim=82800/'$newtimlim'/g' md.in.template > md.$i.in
        qsub bff.$i.sub
        
        #if fisrt available slot has less than 5 hours walltime then move down the list
    elif
        z=$(($i + 1))
        t1=$(grep nid11293 xk.$i.txt | head -$z | tail -1 | awk '{print $4}')
        echo Walltime of $t1 is also available
        t1h=${t1%%:*}
        t1h=$(printf "%.0f\n" $t1h)
        [ "$t1h" -gt "5" ];then
        echo Walltime of $t1h was found on 2nd attempt and is at least 5 hours
        t1s=${t1##*:}
        t1m=${t1%:*}
        t1m=${t1m#*:}
        t1tis=$(($t1h * 3600 + t1m * 60 + t1s))
        fmin=300
        newt1is=$(($t1tis - $fmin))
        newt1h=$((newt1is/3600))
        newt1m=$(echo "($newt1is - (3600 * $newt1h))/60" | bc -l)
        var1=$(printf "%.0f\n" $newt1m)
        #make sure seconds of walltime have 2 digits
        newt1s="00"
        #make sure minutes of walltime have 2 digits, and print walltime
        if [ `expr length "$newt1m"` -gt "1" ];then
            walltime=$(printf "%.0f":"%.0f":"%.0f\n" $newt1h $newt1m $newt1s)
            echo New walltime is $walltime
        else
            walltime=$(printf "%.0f":0"%.0f":"%.0f\n" $newt1h $newt1m $newt1s)
            echo New walltime is $walltime
        fi
        #change timlin for clean exit, set to 30 mins (1800 s) less than new walltime (newt1is)
        newtimlimvar=$(($newt1is - 1800))
        newtimlim='timlim='$newtimlimvar''
        nodes=$(grep nid11293 xk.$i.txt | head -$i | tail -1 | awk '{print $3}')
        geometry=$(grep nid11293 xk.$i.txt | head -$i | tail -1 | awk '{print $7}')
        sed -e 's/WALLTIME/'$walltime'/g' sub.template > bff.$i.sub
        sed -i 's/NODES/'$nodes'/g' bff.$i.sub
        sed -i 's/GEOM/'$geometry'/g' bff.$i.sub
        sed -i 's/JOBNAME/bff.'$i'/g' bff.$i.sub
        sed -i 's/COPY/'$i'/g' bff.$i.sub
        sed -i 's/MDIN/md.'$i'.in/g' bff.$i.sub
        sed 's/timlim=82800/'$newtimlim'/g' md.in.template > md.$i.in
        qsub bff.$i.sub
    else
        echo walltime less than 5 hours
    fi
done
fi
