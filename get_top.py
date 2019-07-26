#! /usr/bin/env python
import cPickle
x = cPickle.load(open('Data/system.dat'))
f = open('topol.prmtop', 'w')
f.write(x.top_string)
g = open('topol.crd', 'w')
g.write(x._mdcrd_string)

