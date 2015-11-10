#!/bin/bash
#trajin same number of frames for both cpptraj steps

tmpstart1=1
tmpstop1=`grep -A 1 "INPUT TRAJECTORIES" tmp.out | awk '{print $11}'`
tmpstart2=$(($tmpstop1 + 1))
tmpstop2=`grep -A 2 "INPUT TRAJECTORIES" tmp.out | tail -1 | awk '{print $11}'`
tmp2stop2=$(($tmpstop2 + $tmpstop1))
tmpstart3=$(($tmp2stop2 + 1))
tmpstop3=`grep -A 3 "INPUT TRAJECTORIES" tmp.out | tail -1 | awk '{print $11}'`
tmp2stop3=$(($tmpstop3 + $tmp2stop2))
start1=$(printf "%.0f\n" $tmpstart1)
stop1=$(printf "%.0f\n" $tmpstop1)
start2=$(printf "%.0f\n" $tmpstart2)
stop2=$(printf "%.0f\n" $tmp2stop2)
start3=$(printf "%.0f\n" $tmpstart3)
stop3=$(printf "%.0f\n" $tmp2stop3)

cpptraj -p /uufs/chpc.utah.edu/common/home/cheatham-group5/james/e2-dna/new-hmr-18mer/traj/complex/nowat.complex.hmr.prmtop << EOF > tmp.out
trajin /uufs/chpc.utah.edu/common/home/cheatham-group5/james/e2-dna/new-hmr-18mer/traj/complex/complex.1.nc 1 last 2500
trajin /uufs/chpc.utah.edu/common/home/cheatham-group5/james/e2-dna/new-hmr-18mer/traj/complex/complex.2.nc 1 last 2500
trajin /uufs/chpc.utah.edu/common/home/cheatham-group5/james/e2-dna/new-hmr-18mer/traj/complex/complex.3.nc 1 last 2500

list
EOF

#
cpptraj << EOF > pca.out
parm /uufs/chpc.utah.edu/common/home/cheatham-group5/james/e2-dna/new-hmr-18mer/traj/complex/nowat.complex.hmr.prmtop
parm strip.nowat.complex.hmr.prmtop
trajin /uufs/chpc.utah.edu/common/home/cheatham-group5/james/e2-dna/new-hmr-18mer/traj/complex/complex.1.nc 1 last 2500
trajin /uufs/chpc.utah.edu/common/home/cheatham-group5/james/e2-dna/new-hmr-18mer/traj/complex/complex.2.nc 1 last 2500
trajin /uufs/chpc.utah.edu/common/home/cheatham-group5/james/e2-dna/new-hmr-18mer/traj/complex/complex.3.nc 1 last 2500

#strip
strip @H=|:19-103,122-206

#rms-fit to first frame
rms first

#create an average structure
average complex-pca-avg.rst7

#save coordinates as 'crd1'
createcrd crd1
run

#fit to average structure
reference complex-pca-avg.rst7 parm strip.nowat.complex.hmr.prmtop

#rms-fit to average structure
crdaction crd1 rms ref complex-pca-avg.rst7

#calculate coordinate covariance matrix
crdaction crd1 matrix covar name complex-pca-Covar

#diagonalize coordinate covariance matrix, get first 5 evecs
runanalysis diagmatrix complex-pca-Covar name mymodes out complex-pca-evecs.dat vecs 5 nmwiz nmwizvecs 5 nmwizfile complex.nmd parmindex 1

#create projections for the trajectory and histograms
crdaction crd1 projection P1 modes mymodes beg 1 end 5 crdframes $start1,$stop1
crdaction crd1 projection P2 modes mymodes beg 1 end 5 crdframes $start2,$stop2
crdaction crd1 projection P3 modes mymodes beg 1 end 5 crdframes $start3,$stop3

#histogram the first 5 projections for each
hist P1:1,*,*,*,100 out complex-1.hist.dat.1 norm name P1-1
hist P1:2,*,*,*,100 out complex-1.hist.dat.2 norm name P1-2
hist P1:3,*,*,*,100 out complex-1.hist.dat.3 norm name P1-3
hist P1:4,*,*,*,100 out complex-1.hist.dat.4 norm name P1-4
hist P1:5,*,*,*,100 out complex-1.hist.dat.5 norm name P1-5
#
hist P2:1,*,*,*,100 out complex-2.hist.dat.1 norm name P2-1
hist P2:2,*,*,*,100 out complex-2.hist.dat.2 norm name P2-2
hist P2:3,*,*,*,100 out complex-2.hist.dat.3 norm name P2-3
hist P2:4,*,*,*,100 out complex-2.hist.dat.4 norm name P2-4
hist P2:5,*,*,*,100 out complex-2.hist.dat.5 norm name P2-5
#
hist P3:1,*,*,*,100 out complex-3.hist.dat.1 norm name P3-1
hist P3:2,*,*,*,100 out complex-3.hist.dat.2 norm name P3-2
hist P3:3,*,*,*,100 out complex-3.hist.dat.3 norm name P3-3
hist P3:4,*,*,*,100 out complex-3.hist.dat.4 norm name P3-4
hist P3:5,*,*,*,100 out complex-3.hist.dat.5 norm name P3-5
#
EOF
