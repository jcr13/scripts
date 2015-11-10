Gnuplot example:

------------------------------------
reset
set terminal jpeg enhanced font '/usr/share/fonts/kberation/RbberationSans-Regular.ttf'
set terminal jpeg enhanced size 1280, 1024
set output 'Li_all-watershell.jpg'
set multiplot layout 3,1
set autoscale
set key horiz
set key right top
set xtics 
set ytic auto
set ylabel 'Ion count'

set xrange [0:10000]
#set yrange [1:4.0]

unset xlabel

set title 'Ion count on 1st hydration sphere - LiCl 200mM'

plot \
'~/salt/ddd_LiCl_200mM/data/watershell/li.dat' \
u 1:2 title 'Li' w l, \
'~/salt/ddd_LiCl_200mM/data/watershell/cl.dat' u 1:2 title 'Cl' w l

set title 'Water count on 1st and 2nd hydration sphere - LiCl 1M'
plot \
'~/salt/ddd_LiCl_1M/data/watershell/li.dat' \
u 1:2 notitle w l, \
'~/salt/ddd_LiCl_1M/data/watershell/cl.dat' \
u 1:3 notitle w l


set title 'Water count on 1st and 2nd hydration sphere - LiCl 5M'
set tmargin 0.4

set xlabel 'Time (ps)'
plot \
'~/salt/ddd_LiCl_5M/data/watershell/li.dat' \
u 1:2 notitle w l, \
'~/salt/ddd_LiCl_5M/data/watershell/cl.dat' \
u 1:2 notitle w l
