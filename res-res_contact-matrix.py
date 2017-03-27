#!/usr/bin/env python

import os
import itertools
from itertools import izip
import subprocess
from subprocess import call
import glob
from aa_321_123 import shorten

d2 = {'C': 'CYS', 'D': 'ASP', 'S': 'SER', 'Q': 'GLN', 'K': 'LYS',
        'I': 'ILE', 'P': 'PRO', 'T': 'THR', 'F': 'PHE', 'N': 'ASN', 
        'G': 'GLY', 'H': 'HIS', 'L': 'LEU', 'R': 'ARG', 'W': 'TRP', 
        'A': 'ALA', 'V':'VAL', 'E': 'GLU', 'Y': 'TYR', 'M': 'MET'}

# need to complete the dictionary
#resd = {'LYS-MET':'26842', 'LYS-THR':'71647', 'LYS-LEU':'149949'}
resd = {'ARG-ARG':'89890',
        'HIS-ARG':'40614',
        'LYS-ARG':'66473',
        'ASP-ARG':'90215',
        'GLU-ARG':'102832',
        'SER-ARG':'78233',
        'THR-ARG':'79669',
        'ASN-ARG':'56813',
        'GLN-ARG':'52651',
        'CYS-ARG':'20540',
        'GLY-ARG':'95750',
        'PRO-ARG':'68394',
        'ALA-ARG':'121959',
        'VAL-ARG':'123806',
        'ILE-ARG':'102032',
        'LEU-ARG':'168895',
        'MET-ARG':'31424',
        'PHE-ARG':'83338',
        'TYR-ARG':'72478',
        'TRP-ARG':'33839',
        'ARG-HIS':'40614',
        'HIS-HIS':'26916',
        'LYS-HIS':'31543',
        'ASP-HIS':'38731',
        'GLU-HIS':'40652',
        'SER-HIS':'40091',
        'THR-HIS':'40965',
        'ASN-HIS':'29090',
        'GLN-HIS':'25109',
        'CYS-HIS':'12101',
        'GLY-HIS':'48599',
        'PRO-HIS':'32103',
        'ALA-HIS':'57769',
        'VAL-HIS':'61239',
        'ILE-HIS':'52135',
        'LEU-HIS':'83161',
        'MET-HIS':'16945',
        'PHE-HIS':'44580',
        'TYR-HIS':'38189',
        'TRP-HIS':'18520',
        'ARG-LYS':'66473',
        'HIS-LYS':'31543',
        'LYS-LYS':'80058',
        'ASP-LYS':'80723',
        'GLU-LYS':'95059',
        'SER-LYS':'69590',
        'THR-LYS':'71647',
        'ASN-LYS':'57707',
        'GLN-LYS':'46677',
        'CYS-LYS':'17625',
        'GLY-LYS':'79659',
        'PRO-LYS':'54232',
        'ALA-LYS':'98782',
        'VAL-LYS':'112495',
        'ILE-LYS':'102690',
        'LEU-LYS':'149949',
        'MET-LYS':'26842',
        'PHE-LYS':'76529',
        'TYR-LYS':'69102',
        'TRP-LYS':'27024',
        'ARG-ASP':'90215',
        'HIS-ASP':'38731',
        'LYS-ASP':'80723',
        'ASP-ASP':'60306',
        'GLU-ASP':'62393',
        'SER-ASP':'68416',
        'THR-ASP':'71703',
        'ASN-ASP':'54079',
        'GLN-ASP':'44696',
        'CYS-ASP':'17583',
        'GLY-ASP':'81068',
        'PRO-ASP':'55112',
        'ALA-ASP':'98574',
        'VAL-ASP':'103925',
        'ILE-ASP':'90154',
        'LEU-ASP':'139807',
        'MET-ASP':'27004',
        'PHE-ASP':'71926',
        'TYR-ASP':'67928',
        'TRP-ASP':'29919',
        'ARG-GLU':'102832',
        'HIS-GLU':'40652',
        'LYS-GLU':'95059',
        'ASP-GLU':'62393',
        'GLU-GLU':'79494',
        'SER-GLU':'71012',
        'THR-GLU':'75626',
        'ASN-GLU':'54465',
        'GLN-GLU':'49203',
        'CYS-GLU':'18403',
        'GLY-GLU':'81660',
        'PRO-GLU':'59564',
        'ALA-GLU':'110381',
        'VAL-GLU':'121018',
        'ILE-GLU':'107556',
        'LEU-GLU':'168549',
        'MET-GLU':'30189',
        'PHE-GLU':'83582',
        'TYR-GLU':'74664',
        'TRP-GLU':'32496',
        'ARG-SER':'78233',
        'HIS-SER':'40091',
        'LYS-SER':'69590',
        'ASP-SER':'68416',
        'GLU-SER':'71012',
        'SER-SER':'81804',
        'THR-SER':'82768',
        'ASN-SER':'61141',
        'GLN-SER':'50581',
        'CYS-SER':'23366',
        'GLY-SER':'92857',
        'PRO-SER':'59421',
        'ALA-SER':'113233',
        'VAL-SER':'123001',
        'ILE-SER':'107302',
        'LEU-SER':'161756',
        'MET-SER':'31461',
        'PHE-SER':'86216',
        'TYR-SER':'73146',
        'TRP-SER':'33815',
        'ARG-THR':'79669',
        'HIS-THR':'40965',
        'LYS-THR':'71647',
        'ASP-THR':'71703',
        'GLU-THR':'75626',
        'SER-THR':'82768',
        'THR-THR':'89056',
        'ASN-THR':'61670',
        'GLN-THR':'52278',
        'CYS-THR':'23132',
        'GLY-THR':'96975',
        'PRO-THR':'62022',
        'ALA-THR':'123829',
        'VAL-THR':'139208',
        'ILE-THR':'119453',
        'LEU-THR':'175623',
        'MET-THR':'33866',
        'PHE-THR':'90380',
        'TYR-THR':'74926',
        'TRP-THR':'34317',
        'ARG-ASN':'56813',
        'HIS-ASN':'29090',
        'LYS-ASN':'57707',
        'ASP-ASN':'54079',
        'GLU-ASN':'54465',
        'SER-ASN':'61141',
        'THR-ASN':'61670',
        'ASN-ASN':'52182',
        'GLN-ASN':'38915',
        'CYS-ASN':'15484',
        'GLY-ASN':'68788',
        'PRO-ASN':'45388',
        'ALA-ASN':'79102',
        'VAL-ASN':'83449',
        'ILE-ASN':'75695',
        'LEU-ASN':'109871',
        'MET-ASN':'22505',
        'PHE-ASN':'61762',
        'TYR-ASN':'56554',
        'TRP-ASN':'24964',
        'ARG-GLN':'52651',
        'HIS-GLN':'25109',
        'LYS-GLN':'46677',
        'ASP-GLN':'44696',
        'GLU-GLN':'49203',
        'SER-GLN':'50581',
        'THR-GLN':'52278',
        'ASN-GLN':'38915',
        'GLN-GLN':'35930',
        'CYS-GLN':'13723',
        'GLY-GLN':'56813',
        'PRO-GLN':'40761',
        'ALA-GLN':'73410',
        'VAL-GLN':'76116',
        'ILE-GLN':'65935',
        'LEU-GLN':'107681',
        'MET-GLN':'20072',
        'PHE-GLN':'54044',
        'TYR-GLN':'46985',
        'TRP-GLN':'22062',
        'ARG-CYS':'20540',
        'HIS-CYS':'12101',
        'LYS-CYS':'17625',
        'ASP-CYS':'17583',
        'GLU-CYS':'18403',
        'SER-CYS':'23366',
        'THR-CYS':'23132',
        'ASN-CYS':'15484',
        'GLN-CYS':'13723',
        'CYS-CYS':'18478',
        'GLY-CYS':'27101',
        'PRO-CYS':'17414',
        'ALA-CYS':'33463',
        'VAL-CYS':'39741',
        'ILE-CYS':'34317',
        'LEU-CYS':'51649',
        'MET-CYS':'10617',
        'PHE-CYS':'27201',
        'TYR-CYS':'21078',
        'TRP-CYS':'10374',
        'ARG-GLY':'95750',
        'HIS-GLY':'48599',
        'LYS-GLY':'79659',
        'ASP-GLY':'81068',
        'GLU-GLY':'81660',
        'SER-GLY':'92857',
        'THR-GLY':'96975',
        'ASN-GLY':'68788',
        'GLN-GLY':'56813',
        'CYS-GLY':'27101',
        'GLY-GLY':'117008',
        'PRO-GLY':'73638',
        'ALA-GLY':'140375',
        'VAL-GLY':'148731',
        'ILE-GLY':'123748',
        'LEU-GLY':'182221',
        'MET-GLY':'38275',
        'PHE-GLY':'97926',
        'TYR-GLY':'83870',
        'TRP-GLY':'39442',
        'ARG-PRO':'68394',
        'HIS-PRO':'32103',
        'LYS-PRO':'54232',
        'ASP-PRO':'55112',
        'GLU-PRO':'59564',
        'SER-PRO':'59421',
        'THR-PRO':'62022',
        'ASN-PRO':'45388',
        'GLN-PRO':'40761',
        'CYS-PRO':'17414',
        'GLY-PRO':'73638',
        'PRO-PRO':'55516',
        'ALA-PRO':'92085',
        'VAL-PRO':'95675',
        'ILE-PRO':'78668',
        'LEU-PRO':'128345',
        'MET-PRO':'24763',
        'PHE-PRO':'65251',
        'TYR-PRO':'60640',
        'TRP-PRO':'29049',
        'ARG-ALA':'121959',
        'HIS-ALA':'57769',
        'LYS-ALA':'98782',
        'ASP-ALA':'98574',
        'GLU-ALA':'110381',
        'SER-ALA':'113233',
        'THR-ALA':'123829',
        'ASN-ALA':'79102',
        'GLN-ALA':'73410',
        'CYS-ALA':'33463',
        'GLY-ALA':'140375',
        'PRO-ALA':'92085',
        'ALA-ALA':'185538',
        'VAL-ALA':'213333',
        'ILE-ALA':'187447',
        'LEU-ALA':'256298',
        'MET-ALA':'53290',
        'PHE-ALA':'139089',
        'TYR-ALA':'106721',
        'TRP-ALA':'51102',
        'ARG-VAL':'123806',
        'HIS-VAL':'61239',
        'LYS-VAL':'112495',
        'ASP-VAL':'103925',
        'GLU-VAL':'121018',
        'SER-VAL':'123001',
        'THR-VAL':'139208',
        'ASN-VAL':'83449',
        'GLN-VAL':'76116',
        'CYS-VAL':'39741',
        'GLY-VAL':'148731',
        'PRO-VAL':'95675',
        'ALA-VAL':'213333',
        'VAL-VAL':'244172',
        'ILE-VAL':'227939',
        'LEU-VAL':'299755',
        'MET-VAL':'60332',
        'PHE-VAL':'163297',
        'TYR-VAL':'119075',
        'TRP-VAL':'54421',
        'ARG-ILE':'102032',
        'HIS-ILE':'52135',
        'LYS-ILE':'102690',
        'ASP-ILE':'90154',
        'GLU-ILE':'107556',
        'SER-ILE':'107302',
        'THR-ILE':'119453',
        'ASN-ILE':'75695',
        'GLN-ILE':'65935',
        'CYS-ILE':'34317',
        'GLY-ILE':'123748',
        'PRO-ILE':'78668',
        'ALA-ILE':'187447',
        'VAL-ILE':'227939',
        'ILE-ILE':'199678',
        'LEU-ILE':'280187',
        'MET-ILE':'53041',
        'PHE-ILE':'146734',
        'TYR-ILE':'107488',
        'TRP-ILE':'46366',
        'ARG-LEU':'168895',
        'HIS-LEU':'83161',
        'LYS-LEU':'149949',
        'ASP-LEU':'139807',
        'GLU-LEU':'168549',
        'SER-LEU':'161756',
        'THR-LEU':'175623',
        'ASN-LEU':'109871',
        'GLN-LEU':'107681',
        'CYS-LEU':'51649',
        'GLY-LEU':'182221',
        'PRO-LEU':'128345',
        'ALA-LEU':'256298',
        'VAL-LEU':'299755',
        'ILE-LEU':'280187',
        'LEU-LEU':'311012',
        'MET-LEU':'80095',
        'PHE-LEU':'213036',
        'TYR-LEU':'157815',
        'TRP-LEU':'75460',
        'ARG-MET':'31424',
        'HIS-MET':'16945',
        'LYS-MET':'26842',
        'ASP-MET':'27004',
        'GLU-MET':'30189',
        'SER-MET':'31461',
        'THR-MET':'33866',
        'ASN-MET':'22505',
        'GLN-MET':'20072',
        'CYS-MET':'10617',
        'GLY-MET':'38275',
        'PRO-MET':'24763',
        'ALA-MET':'53290',
        'VAL-MET':'60332',
        'ILE-MET':'53041',
        'LEU-MET':'80095',
        'MET-MET':'20988',
        'PHE-MET':'42220',
        'TYR-MET':'31484',
        'TRP-MET':'14834',
        'ARG-PHE':'83338',
        'HIS-PHE':'44580',
        'LYS-PHE':'76529',
        'ASP-PHE':'71926',
        'GLU-PHE':'83582',
        'SER-PHE':'86216',
        'THR-PHE':'90380',
        'ASN-PHE':'61762',
        'GLN-PHE':'54044',
        'CYS-PHE':'27201',
        'GLY-PHE':'97926',
        'PRO-PHE':'65251',
        'ALA-PHE':'139089',
        'VAL-PHE':'163297',
        'ILE-PHE':'146734',
        'LEU-PHE':'213036',
        'MET-PHE':'42220',
        'PHE-PHE':'116994',
        'TYR-PHE':'87878',
        'TRP-PHE':'40961',
        'ARG-TYR':'72478',
        'HIS-TYR':'38189',
        'LYS-TYR':'69102',
        'ASP-TYR':'67928',
        'GLU-TYR':'74664',
        'SER-TYR':'73146',
        'THR-TYR':'74926',
        'ASN-TYR':'56554',
        'GLN-TYR':'46985',
        'CYS-TYR':'21078',
        'GLY-TYR':'83870',
        'PRO-TYR':'60640',
        'ALA-TYR':'106721',
        'VAL-TYR':'119075',
        'ILE-TYR':'107488',
        'LEU-TYR':'157815',
        'MET-TYR':'31484',
        'PHE-TYR':'87878',
        'TYR-TYR':'73356',
        'TRP-TYR':'34454',
        'ARG-TRP':'33839',
        'HIS-TRP':'18520',
        'LYS-TRP':'27024',
        'ASP-TRP':'29919',
        'GLU-TRP':'32496',
        'SER-TRP':'33815',
        'THR-TRP':'34317',
        'ASN-TRP':'24964',
        'GLN-TRP':'22062',
        'CYS-TRP':'10374',
        'GLY-TRP':'39442',
        'PRO-TRP':'29049',
        'ALA-TRP':'51102',
        'VAL-TRP':'54421',
        'ILE-TRP':'46366',
        'LEU-TRP':'75460',
        'MET-TRP':'14834',
        'PHE-TRP':'40961',
        'TYR-TRP':'34454',
        'TRP-TRP':'19184'}

pwd = os.getcwd()
outdir = "%s/res-res_files" % pwd
seq_file = 'sequence.dat'
with open(seq_file, 'r') as inp_seq:
    aa_seq = inp_seq.read().replace('\n', '')
    seq_len = len(aa_seq)
res_matrix_file = 'res-res_matrix.dat'
with open(res_matrix_file, 'r') as res_inp:
    res = res_inp.read()
    #res = res_inp.read().replace('\n', '')

# Convert single letter aa to three letter,  may need to manipulate
#   dictionary 'd' depending on input or format input for this script.
def lengthen(x):
    if len(x) % 1 != 0:
        raise ValueError('Input length should be a multiple of one')

    y = ''
    for i in range(len(x)):
        y += d2[x[i]]
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
    
    proc = subprocess.call('paste %s/*.dat > res-res_matrix.dat' % outdir, shell=True)
    
# replace residue w/ top8000 data
def mat_search_replace(text, dic):
    for i, j in  dic.iteritems():
        text = text.replace(i, j)
    #return text
    print(text)

# stdout redirected to 3gb1_res-res_restraints.tmp, then cleaned with clean_res-res_restraints.sh
# and redirected to 3gb1_res-res_restraints.txt
def mat_assoc(text, dic):
    for i, j in dic.iteritems():
        if int(j) > 150000:
            replaced_pair = (i)
            print(replaced_pair)
        else:
            pass

# write a two column file that contains the residue number for all possible res-res
#   contacts that are in 3gb1_res-res_restraints.txt (satisfy top 50% of top8000)
def restraints():
    llen =  len(aa_seq)
    res1list = []
    res2list = []
    resfile = open('3gb1_res-res_restraints.txt', 'r')
    for line in resfile.readlines():
        line = line.strip()
        x = line.split('-')
        aa1 = shorten(x[0])
        aa2 = shorten(x[1])
        res1list.append(aa1)
        res2list.append(aa2)
    outfile = 'pseudo_evolution_contacts.dat'
    with open(outfile, 'w') as outp:
        for x,y in izip(res1list,res2list):
            res1 = [i+1 for i, s in enumerate(aa_seq) if x in s]
            res2 = [i+1 for i, s in enumerate(aa_seq) if y in s]
            res1res2 = list(itertools.product(res1, res2))
            # make sure residues are more than 3 apart
            for a,b in res1res2:
                diff = abs(a-b)
                if diff > 3:
                    aas = "%s\t%s\n" % (a, b)
                    outp.write(aas)
                    print(a,x,b,y)
                else:
                    pass
    outp.close()


#lengthen(aa_seq)
#
#res_res()
#
#pop_matrix()
#
#mat_search_replace(res, resd)
#
#mat_assoc(res, resd)
#
restraints()
