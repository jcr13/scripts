#!/usr/bin/env python

# convert three letter aa representation to single letter 'shorten' or 
#   convert single letter aa to three letter 'lengthen'
#   may need to manipulate dictionaries 'd' and 'd2' depending on input
#   or format input for this script

d = {'CYS': 'C', 'ASP': 'D', 'SER': 'S', 'GLN': 'Q', 'LYS': 'K',
        'ILE': 'I', 'PRO': 'P', 'THR': 'T', 'PHE': 'F', 'ASN': 'N', 
        'GLY': 'G', 'HIS': 'H', 'LEU': 'L', 'ARG': 'R', 'TRP': 'W', 
        'ALA': 'A', 'VAL':'V', 'GLU': 'E', 'TYR': 'Y', 'MET': 'M'}

d2 = {'C': 'CYS', 'D': 'ASP', 'S': 'SER', 'Q': 'GLN', 'K': 'LYS',
        'I': 'ILE', 'P': 'PRO', 'T': 'THR', 'F': 'PHE', 'N': 'ASN', 
        'G': 'GLY', 'H': 'HIS', 'L': 'LEU', 'R': 'ARG', 'W': 'TRP', 
        'A': 'ALA', 'V':'VAL', 'E': 'GLU', 'Y': 'TYR', 'M': 'MET'}


def shorten(x):
    if len(x) % 3 != 0: 
        raise ValueError('Input length should be a multiple of three')
    
    y = ''
    for i in range(len(x)/3):
        y += d[x[3*i:3*i+3]]
        #return y
    #print(y)

def lengthen(x):
    if len(x) % 1 != 0:
        raise ValueError('Input length should be a multiple of one')

    y = ''
    for i in range(len(x)):
        y += d2[x[i]]
        #return y
    z = [y[i:i+3] for i in range(0, len(y), 3)]
    return(z)
    #print "%s\n" % (z)


#lengthen('MTYKLILNGKTLKGETTTEAVDAATAEKVFKQYANDNGVDGEWTYDDATKTFTVTE')

#shorten('ARGHISLEULEULYS')

