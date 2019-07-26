#! /usr/bin/env python
import sys
import numpy

i = int(sys.argv[1])
print "MODEL %i" % i 
fn = open('unique.c{}.pdb'.format(i))
errors = numpy.loadtxt('back.{}.apf'.format(i))
errors = errors[:,1]
for line in fn:
    line = line.strip()
    if "ATOM" in line:
        line = line.replace('HIE','HIS')
        resnum = int(line.split()[4]) - 1
        print "{0}1.00 {1:5.2f}".format(line[:55],errors[resnum])
print "TER"
print "END"
