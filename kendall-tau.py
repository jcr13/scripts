#!/usr/bin/env python

import sys
from scipy.stats import kendalltau as kt

def ktnativecontacts():
    """Read in two lists and calculate kendall tau correlation.
    It's important that the lists have the same system order e.g. if I want
    to calc kt for experimental dG and MELD Tms, I will have two files each
    with two columns of data - column 1 is system ID, column 2 is dG or Tm -
    but the files will have the data in the same order, according to system ID.
    """
    # open experimental dG file
    dGfile = open(sys.argv[1], 'r')
    lines = dGfile.readlines()
    dG = []
    for x in lines:
        dG.append(x.split( )[1])
    dGfile.close()

    # open meld folding data file
    tmfile = open(sys.argv[2], 'r')
    lines = tmfile.readlines()
    tm = []
    for x in lines:
        tm.append(x.split( )[1])
    tmfile.close()

    # calc kt corr
    ktcorr = kt(dG, tm)

    print(dG)
    
    print(tm)

    print(ktcorr)

# call ktnativecontacts
ktnativecontacts()
