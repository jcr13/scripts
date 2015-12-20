#!/bin/bash
set -x

cpptraj=`which cpptraj`

for ff in ez1ol4b1;
do
    for wat in opc tip3p;
    do
	cd ~/ff-battles/ddd/$ff/$wat
	
$cpptraj <<EOF
parm vacuo.topo
trajin aggregate.nc 1 last 100

check @N1,N2,P,OP1,OP2,C1',C2',C3',C4',O3',O4' skipbadframes silent

reference /uufs/chpc.utah.edu/common/home/u0818159/ddd-references/1naj/ddd-nmr-average-amber-names.pdb
rms reference :1-24&!@H= out data/rms_ref.dat time 200
rms reference :3-10,15-22&!@H= out data/rms_ref-internal.dat time 200


atomicfluct out data/fluct_byatom_bfactor.dat :1-24 bfactor
atomicfluct out data/fluct_byres_bfactor.dat :1-24 byres bfactor
atomicfluct out data/fluct_byatom.dat :1-24
atomicfluct out data/fluct_byres.dat :1-24 byres

distance e1 out data/end-to-end-bp1.dat :1,24 :12,13 time 200
distance e2 out data/end-to-end-bp2.dat :2,23 :11,14 time 200
distance e3 out data/end-to-end-bp3.dat :3,22 :10,15 time 200

nastruct NA1 reference resrange 3-10,15-22

run

writedata data/major.dat NA1[major]
writedata data/minor.dat NA1[minor]
writedata data/helical-twist.dat NA1[htwist]
writedata data/helical-inclination.dat NA1[incl]

writedata data/hb.dat NA1[hb]

writedata data/shear.dat NA1[shear]
writedata data/buckle.dat NA1[buckle]
writedata data/stretch.dat NA1[stretch]
writedata data/stagger.dat NA1[stagger]
writedata data/prop.dat NA1[prop]
writedata data/opening.dat NA1[open]

writedata data/shift.dat NA1[shift]
writedata data/tilt.dat NA1[tilt]
writedata data/slide.dat NA1[slide]
writedata data/rise.dat NA1[rise]
writedata data/roll.dat NA1[roll]
writedata data/twist.dat NA1[twist]

EOF


	done

done