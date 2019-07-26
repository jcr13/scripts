#! /usr/bin/env python

import sys 
import numpy

confidence = []
prediction = []
with open(sys.argv[1],'r') as fo:
    for l in fo:
        if "Conf" in l:
            confidence.extend(list(l.split()[1]))
        elif "Pred" in l:
            prediction.extend(list(l.split()[1]))
        else:
            continue

confidence = numpy.array([int(i) for i in confidence])
prediction = numpy.array(prediction)
lower = confidence < 5
prediction[lower] = '.'
coil = prediction == 'C'
prediction[coil] = '.'
print ''.join(prediction)
