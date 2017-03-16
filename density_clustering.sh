#! /bin/bash
#$ -S /bin/bash
#$ -R yes
#$ -V
#$ -cwd
#$ -N Replica
#$ -j y
#$ -q cpu_short
#$ -P kenprj


for r in 2
do


    #Select residues on which to do the clustering
cat<<EOF>get_res.py
#! /usr/bin/env python

f = open('ss.dat','r')

l = f.readlines()[0].rstrip()

ok = False
res = []
for i,s in enumerate(l):
    if ok and s not in 'HE':
        ok = False
        end = i
        res.append("{}-{}".format(ini,end))

    if (s in 'HE'):
        if not ok:
            ok = True
            ini = i + 1
        if (ok):
            pass


print ":{}".format(",".join(res))
EOF

res=`python ./get_res.py`
echo $res

#generate topology
cat<<EOF>get_top.py
#! /usr/bin/env python
import cPickle
x = cPickle.load(open('Data/system.dat'))
f = open('topol.top', 'w')
f.write(x.top_string)
EOF
python get_top.py

rm -r Cpptraj_density_sieve_eps_$r
mkdir Cpptraj_density_sieve_eps_$r
cd Cpptraj_density_sieve_eps_$r

cat<<EFO>cpptraj.in
trajin ../trajectory.00.dcd 5000 50000
trajin ../trajectory.01.dcd 5000 50000
trajin ../trajectory.02.dcd 5000 50000
trajin ../trajectory.03.dcd 5000 50000
trajin ../trajectory.04.dcd 5000 50000
rms PredSSE first ${res}@CA,CB out trajrmsd.dat
cluster dpeaks epsilon $r noise dvdfile density_vs_dist.dat choosepoints manual distancecut 4.0 densitycut 250   rms ${res}@CA,CB summary summary singlerepout representative repout unique repfmt pdb clusterout clusttraj  avgout avg avgfmt pdb 
go
EFO

for j in 0 1 2 3 4 5 6 7 8 9 
do
    cat<<EOF>>cpptraj.in
   clear trajin
   trajin  clusttraj.c$j
   trajout clusttraj.c$j.pdb model
   average average.c$j.pdb pdb
   reference unique.c$j.pdb [uniq$j]
   rms centr$j ref [uniq$j] @CA 
   atomicfluct out back.$j.apf @C,CA,N,O byres
   go
EOF
done




~alberto/amber_git/amber/bin/cpptraj -p ../topol.top -i cpptraj.in
cd ..
done


