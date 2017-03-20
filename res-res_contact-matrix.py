#!/usr/bin/env python

import os
import itertools
from itertools import izip

d = {'C': 'CYS', 'D': 'ASP', 'S': 'SER', 'Q': 'GLN', 'K': 'LYS',
        'I': 'ILE', 'P': 'PRO', 'T': 'THR', 'F': 'PHE', 'N': 'ASN', 
        'G': 'GLY', 'H': 'HIS', 'L': 'LEU', 'R': 'ARG', 'W': 'TRP', 
        'A': 'ALA', 'V':'VAL', 'E': 'GLU', 'Y': 'TYR', 'M': 'MET'}

pwd = os.getcwd()
outdir = "%s/res-res_files" % pwd
seq_file = 'sequence.dat'
with open(seq_file, 'r') as inp_seq:
    aa_seq = inp_seq.read().replace('\n', '')
    seq_len = len(aa_seq)

# Convert single letter aa to three letter,  may need to manipulate
#   dictionary 'd' depending on input or format input for this script.
def lengthen(x):
    if len(x) % 1 != 0:
        raise ValueError('Input length should be a multiple of one')

    y = ''
    for i in range(len(x)):
        y += d[x[i]]
    z = [y[i:i+3] for i in range(0, len(y), 3)]
    #print "%s\n" % (z)
    return z

# Write pair_file.dat which has all NxN pairs for a given sequence where
#   N = sequence length.
def res_res():
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

def pop_matrix():
    pair_file = 'pair_list.dat'
    split_delim = int(seq_len)
    with open(pair_file, 'r') as f:
        for i, l in enumerate(f):
            pass
        pair_file_len = i + 1
    with open(pair_file, 'r') as f:
        for x in range(0, pair_file_len, split_delim):
            y = x + split_delim
            outfile = "%s/%04d.dat" % (outdir, x)
            with open("%s" % outfile, 'w') as outp:
                nth_lines = itertools.islice(f, 0, split_delim, 1)
                for line in nth_lines:
                    new_row = "%s" % line
                    outp.write(new_row)
                outp.close()
    f.close()
                    #print(new_row)
    
lengthen(aa_seq)

res_res()

pop_matrix()
