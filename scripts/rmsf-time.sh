bash script to generate the little atomicfluct files
-----------------------------------------------------------------------------
#!/bin/bash
#set -x

for canion in Li Na K Rb Cs Mg Mn Ca;
do

 for anion in Cl Br I;
 do

   for conc in 200mM 1M 5M;
   do
     path='ddd_'$canion''$anion'_'$conc
     cd ~/salt/$path
     cd data
     pwd
     echo $path
     echo $canion

     rm -rf bfactors/
     mkdir bfactors

     start=0
     for i in {1..1000}
     do

let end=$start+1000

cpptraj <<EOF
parm ../ddd-nowater.topo
trajin ../traj_nowater.nc $start $end 1
autoimage
rms first mass :1-24
atomicfluct out bfactors/fluct_byatom_bfactor_$start-$end.dat :1-24 bfactor
atomicfluct out bfactors/fluct_byres_bfactor_$start-$end.dat :1-24 byres bfactor
EOF
       let "start +=1000"
     done

     ~/salt/analysis/bfactor-time/format.pl $path

   done
 done
done
