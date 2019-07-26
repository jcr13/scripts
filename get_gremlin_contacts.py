#! /usr/bin/env python
# get all contacts above s_sco cutoff from results.gremlin based on seq_len and 
#  considering Prob >= 0.7; output to contacts.dat
# if using with MELD evolutionary contact restraints, adjust accuracy to 0.7
# s_sco based on plot from http://gremlin.bakerlab.org/gremlin_faq.php

import os

seq_len_f='results.err'
gremlin_contacts_f='results.gremlin'
outfile='evolution_contacts.dat'

# check if files exist
try:
    with open(seq_len_f) as file:
        pass
except IOError as e:
    print "Unable to open file results.err" #Does not exist OR no read permissions

try:
    with open(gremlin_contacts_f) as file:
        pass
except IOError as e:
    print "Unable to open file results.gremlin" #Does not exist OR no read permissions

# get seq_len value from seq_len_f
seq_len = open(seq_len_f, 'r')
for line in seq_len.readlines():
    seq_len = line.split()[-1]

# get contacts from gremlin_contacts_f
"""
for 0.70 probability, use the following cutoffs

seq_len < 0.5           no Gremlin contacts
0.5 <= seq_len < 1.0     s_sco > 1.75
1.0 <= seq_len < 2.0     s_sco > 1.40
2.0 <= seq_len < 5.0     s_sco > 1.10
5.0 <= seq_len < 10.0    s_sco > 0.85
seq_len >= 10.0          s_sco > 0.75
"""

gremlin_contacts=open(gremlin_contacts_f, 'r')
meld_contacts=open(outfile, 'w')
for line in gremlin_contacts.readlines()[1:]:
    s_sco = line.split()[6]
    i = line.split()[0]
    j = line.split()[1]
    contacts = ('%s\t%s\n') % (i, j)

    if ( seq_len >= '10' and s_sco >= '0.75' ):
        meld_contacts.write(contacts)
    else:
        pass

    if ( '5' <= seq_len < '10' and s_sco >= '0.85'):
        meld_contacts.write(contacts)
    else:
        pass

    if ( '2' <= seq_len < '5' and s_sco >= '1.10'):
        meld_contacts.write(contacts)
    else:
        pass

    if ( '1' <= seq_len < '2' and s_sco >= '1.40'):
        meld_contacts.write(contacts)
    else:
        pass

    if ( '0.5' <= seq_len < '1' and s_sco >= '1.75'):
        meld_contacts.write(contacts)
    else:
        pass

    if ( seq_len < '0.5' ):
        pass

