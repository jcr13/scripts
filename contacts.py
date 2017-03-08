#!/usr/bin/env python
# write cpptraj scripts for all combinations of residue pairs to analyze contacts
# between each residue pair

import os
import re
import itertools
import subprocess
import numpy as np
from itertools import izip
from subprocess import call

res = ['ARG', 'HIS', 'LYS', 'ASP', 'GLU', 'SER', 'THR', 'ASN', 'GLN', 'CYS', 
        'GLY', 'PRO', 'ALA', 'VAL', 'ILE', 'LEU', 'MET', 'PHE', 'TYR', 'TRP']
pdbdir = "/home/james/dill/res-res_contacts/pdbs"
contactsdir = "/home/james/dill/res-res_contacts/contacts_dat"
statsdir = "/home/james/dill/res-res_contacts/contact_stats"
statslist = os.listdir(statsdir)
pdblist = os.listdir(pdbdir)

# generate all possible residue-residue pairs from res list and write to file
def residue_pairs(reslist):
    pair_file = open('pair_list.dat', 'w')
    for res1, res2 in itertools.combinations(reslist, 2):
        res1 = res1.strip()
        res2 = res2.strip()
        new_pair = "%s \t %s" % (res1, res2)
        pair_file.write("%s\n" % new_pair)
    pair_file.close()

# write cpptraj input for each residue residue contact
def cpptraj_in(sys, reslist):
    infile = open('cpptraj.%s.in' % sys, 'w') 
    parm = "parm %s/%s\n" % (pdbdir, sys)
    infile.write(parm)
    trajin = "trajin %s/%s 1 1 1\n \n" % (pdbdir, sys)
    infile.write(trajin)
    for res1, res2 in itertools.combinations(reslist, 2):
        res1 = res1.strip()
        res2 = res2.strip()
        contacts = "nativecontacts :%s :%s resout %s/%s_%s-%s.dat distance 7.0 byresidue resoffset 4\nrun\n \n" \
                % (res1, res2, contactsdir, sys, res1, res2)
        infile.write(contacts)
        # run cpptraj
        cpptraj = subprocess.call("cpptraj -i cpptraj.%s.in > cpptraj.%s.out" % (sys, sys), shell=True)
    infile.close()

# calculate statistics on all of the res-res contacts
def contact_stats(sys, reslist):
    for each_sys in sys:
        statfile = open("%s/%s.dat" % (statsdir, sys), 'w')
        for res1, res2 in itertools.combinations(reslist, 2):
            res1 = res1.strip()
            res2 = res2.strip()
            if os.path.isfile("%s/%s_%s-%s.dat" % (contactsdir, sys, res1, res2)):
                with open("%s/%s_%s-%s.dat" % (contactsdir, sys, res1, res2)) as f:
                    for i, l in enumerate(f):
                        pass
                    wc = i
                    statfile.write("%s %s COUNT: %i\n" % (res1, res2, wc))
            else:
                continue
        statfile.close()

# extract the total number of occurrences of each res-res pair from each system
# in the PDB.pdb.dat file, and sum across systems. Write the sum across systems
# to new outfile e.g. if there are 4 pdb files, the outfile will have 4 values,
# 1 for each system
def get_count(reslist):
    for res1, res2 in itertools.combinations(reslist, 2):
        res1 = res1.strip()
        res2 = res2.strip()
        outfile = open("%s/%s-%s.dat" % (statsdir, res1, res2), 'w')
        for eachfile in statslist:
            statfile = "%s/%s" % (statsdir, eachfile)
            with open("%s" % (statfile)) as f:
                for line in f: 
                    line = line.strip()
                    if "%s %s COUNT:" % (res1, res2) in line: 
                        x = line[-2:]
                        #print(float(x))
                        outfile.write("%s\n" % float(x))
    outfile.close()

# sum the values from the get_count function to get the total number of res-
# res contacts over all systems studied e.g. If there were 4 systems and 
# 0, 0, 17, 5 contacts b/w ALA-VAL in the 4 systems the total will be 22
def sum_total(reslist):
    for res1, res2 in itertools.combinations(reslist, 2):
        res1 = res1.strip()
        res2 = res2.strip()
        readfile = "%s/%s-%s.dat" % (statsdir, res1, res2)
        outfile = "%s/%s-%s.sum.dat" % (statsdir, res1, res2)
        total = 0
        with open("%s" % readfile, 'r') as inp, open("%s" % outfile, "w") as outp:
            for line in inp:
                try:
                    num = float(line)
                    total += num
                    #outp.write(line)
                    #outp.write("%s %s Total: {}\n".format(total) % (res1, res2))
                except ValueError:
                    print('{} is not a number!'.format(line))
            outp.write("%s %s Total: {}\n".format(total) % (res1, res2))

        #print('Total: {}'.format(total))
    outp.close()

# call residue_pairs with res (pdb appropriate) list of residues
# this output shouldn't change from run to run
residue_pairs(res)

# loop through all pdbs in pdbdir to write cpptraj input, then run cpptraj
for pdb in pdblist:
    cpptraj_in(pdb, res) # call cpptraj_in for each pdb w/ residue list

# call contact_stats
for pdb in pdblist:
    contact_stats(pdb, res)

# call get_count
get_count(res)

# call sum_total
sum_total(res)
