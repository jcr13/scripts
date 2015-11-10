#!/bin/bash
#set -x
## ABI
## Delete tmp files
rm abi.dat

cpptraj='/home/ros/Documents/GIT/cpptraj/bin/cpptraj'

for bp in 4 5 6 7 8 9 10 11 12 13;
do
    let nextbp=$bp+1
    let prev=37-$bp
    let prevv=37-$nextbp

    ## Change the mask depending if it is R or Y
    if [ "$bp" == 4 -o "$bp" == 8 -o "$bp" == 12 ];
	then
	dihedral="dihedral DI$bp :$bp@O4' :$bp@C1' :$bp@N1 :$bp@C2 out _CHI.dat"
    else
	dihedral="dihedral DI$bp :$bp@O4' :$bp@C1' :$bp@N9 :$bp@C4 out _CHI.dat"
    fi

    for frame in {1..10000};
    do

	echo "FRAME: "$frame

	$cpptraj <<EOF
noprogress
parm ../vacuo.topo
trajin ../vacuo.crd $frame $frame 1
reference ../avg0.pdb
$dihedral
nastruct NA$bp reference resrange $bp-$nextbp,$prevv-$prev
run
writedata _ZP.dat NA$bp[zp]
EOF

	## Delete first line (header) of the temp files
	sed -i '1d' _*

	## Calculate the ABI index for this set of numbers
	chi=`awk '{print $2}' _CHI.dat`
	zp=`awk '{print $2}' _ZP.dat`

#	echo "ZP: "$zp
	zp2=$(echo "($zp-2.2)/-2.6" |bc -l)
#	echo "ZP norm: "$zp2
#	echo "CHI: "$chi
	chi2=$(echo "($chi-(-157))/49" |bc -l)
#	echo "Norm chi: "$chi2
	abi=$(echo "($zp2+$chi2)/2" |bc -l)
#	echo "ABI: "$abi
	
	echo $bp $frame $abi >> abi.dat

	let frame=$frame+1

	#    printf $frame; %.4f $abi >>abi.dat
    done

    echo '' >> abi.dat
done

## CLEAN TEMPS
rm _*
