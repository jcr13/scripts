#!/bin/bash
DIR=/cavern/jamesr/nonthreadable/1nd9
# generate topolgy
cd $DIR

cat<< EOF >get_top.py
#!/usr/bin/env python
import cPickle
x = cPickle.load(open('Data/system.dat'))
f = open('topol.prmtop', 'w')
f.write(x.top_string)
EOF

python get_top.py
