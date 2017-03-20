#!/usr/bin/env python
#   Convert single letter aa to three letter 'lengthen' may need to manipulate
#   dictionaries 'd' depending on input or format input for this script. Then
#   write pair_file.dat which has all NxN pairs for a given sequence where
#   N = sequence length.

import itertools
from itertools import izip

d = {'C': 'CYS', 'D': 'ASP', 'S': 'SER', 'Q': 'GLN', 'K': 'LYS',
        'I': 'ILE', 'P': 'PRO', 'T': 'THR', 'F': 'PHE', 'N': 'ASN', 
        'G': 'GLY', 'H': 'HIS', 'L': 'LEU', 'R': 'ARG', 'W': 'TRP', 
        'A': 'ALA', 'V':'VAL', 'E': 'GLU', 'Y': 'TYR', 'M': 'MET'}

seq_file = 'sequence.dat'
with open(seq_file, 'r') as inp_seq:
    aa_seq = inp_seq.read().replace('\n', '')

def lengthen(x):
    if len(x) % 1 != 0:
        raise ValueError('Input length should be a multiple of one')

    y = ''
    for i in range(len(x)):
        y += d[x[i]]
    z = [y[i:i+3] for i in range(0, len(y), 3)]
    #print "%s\n" % (z)
    return z

def b_array():
    pair_file = open('pair_list.dat', 'w')
    seq_list = lengthen(aa_seq)
    # iterate over items in seq_list to combine with all others
    llen =  len(seq_list)
    for res1 in seq_list:
        for x in range(0, int(llen)):
            y = x + 1
            res2 = ','.join(seq_list[x:y])
            new_pair = "%s-%s" % (res1, res2)
            pair_file.write("%s\n" % new_pair)
    pair_file.close()
            #print "%s-%s" % (res1, res2)

lengthen(aa_seq)

b_array()
