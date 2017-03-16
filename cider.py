#!/usr/bin/env python

# import a few things...
import localcider
import os
import shutil
from localcider.sequenceParameters import SequenceParameters
from localcider import plots

#
successpath = "/cavern/jamesr/meld_successes-and-failures/fasta_successes/clean/"
failpath = "/cavern/jamesr/meld_successes-and-failures/fasta_failures/clean/"
successfilelist = os.listdir(successpath)
failfilelist = os.listdir(failpath)
soutdir = "/cavern/jamesr/meld_successes-and-failures/cider_successes/"
foutdir = "/cavern/jamesr/meld_successes-and-failures/cider_failures/"
successseqlenfile = "/cavern/jamesr/meld_successes-and-failures/cider_successes/successes_seq-length.dat"
failseqlenfile = "/cavern/jamesr/meld_successes-and-failures/cider_failures/failures_seq-length.dat"
successfracexpfile = "/cavern/jamesr/meld_successes-and-failures/cider_successes/successes_frac-expanding.dat"
failfracexpfile = "/cavern/jamesr/meld_successes-and-failures/cider_failures/failures_frac-expanding.dat"
successfracchrgfile = "/cavern/jamesr/meld_successes-and-failures/cider_successes/successes_frac-charged.dat"
failfracchrgfile = "/cavern/jamesr/meld_successes-and-failures/cider_failures/failures_frac-charged.dat"
successmeanchrgfile = "/cavern/jamesr/meld_successes-and-failures/cider_successes/successes_mean-charge.dat"
failmeanchrgfile = "/cavern/jamesr/meld_successes-and-failures/cider_failures/failures_mean-charge.dat"
successfracdisfile = "/cavern/jamesr/meld_successes-and-failures/cider_successes/successes_frac-disorder-promoting.dat"
failfracdisfile = "/cavern/jamesr/meld_successes-and-failures/cider_failures/failures_frac-disorder-promoting.dat"
successhydfile = "/cavern/jamesr/meld_successes-and-failures/cider_successes/successes_mean-hydropathy.dat"
failhydfile = "/cavern/jamesr/meld_successes-and-failures/cider_failures/failures_mean-hydropathy.dat"
successphasefile = "/cavern/jamesr/meld_successes-and-failures/cider_successes/successes_phase-region.dat"
failphasefile = "/cavern/jamesr/meld_successes-and-failures/cider_failures/failures_phase-region.dat"

if os.path.exists(soutdir):
    shutil.rmtree(soutdir)
os.makedirs(soutdir)
if os.path.exists(foutdir):
    shutil.rmtree(foutdir)
os.makedirs(foutdir)

# create empty lists
list_of_SeqObjs = []
pdbs = []

# populate that list with SequenceParameters objects, which we construct from the
# sequence found in each file
# meld successes
os.chdir(successpath)
seqlenfile = open(successseqlenfile, 'a')
expfile = open(successfracexpfile, 'a')
chrgfile = open(successfracchrgfile, 'a')
mchrgfile = open(successmeanchrgfile, 'a')
disfile = open(successfracdisfile, 'a')
hydfile = open(successhydfile, 'a')
phasefile = open(successphasefile, 'a')
for file in successfilelist:
    try:
        list_of_SeqObjs.append(SequenceParameters(sequenceFile=file))
    except localcider.SequenceFileParserException:
        # if we encounter a file parsing error just skip that sequence
        continue
    # take last digits of file name as pdb id
    pdbs.append(file[-4:])

# for each
for pdb, obj  in zip(pdbs, list_of_SeqObjs):
    seqlen = ("%s \t %i" % (pdb, obj.get_length()))
    fracexp = ("%s \t %.2f" % (pdb, obj.get_fraction_expanding()))
    fracchrg = ("%s \t %.2f" % (pdb, obj.get_FCR()))
    meanchrg = ("%s \t %.2f" % (pdb, obj.get_mean_net_charge()))
    fracdis = ("%s \t %.2f" % (pdb, obj.get_fraction_disorder_promoting()))
    hydrophob = ("%s \t %.2f" % (pdb, obj.get_mean_hydropathy()))
    phase = ("%s \t %i" % (pdb, obj.get_phasePlotRegion()))

    # print to file
    seqlenfile.write(seqlen)
    seqlenfile.write("\n")
    expfile.write(fracexp)
    expfile.write("\n")
    chrgfile.write(fracchrg)
    chrgfile.write("\n")
    mchrgfile.write(meanchrg)
    mchrgfile.write("\n")
    disfile.write(fracdis)
    disfile.write("\n")
    hydfile.write(hydrophob)
    hydfile.write("\n")
    phasefile.write(phase)
    phasefile.write("\n")
    
seqlenfile.close()
expfile.close()
chrgfile.close()
mchrgfile.close()
disfile.close()
hydfile.close()
phasefile.close()

# meld failures
os.chdir(failpath)
seqlenfile = open(failseqlenfile, 'a')
expfile = open(failfracexpfile, 'a')
chrgfile = open(failfracchrgfile, 'a')
mchrgfile = open(failmeanchrgfile, 'a')
disfile = open(failfracdisfile, 'a')
hydfile = open(failhydfile, 'a')
phasefile = open(failphasefile, 'a')
for file in failfilelist:
    try:
        list_of_SeqObjs.append(SequenceParameters(sequenceFile=file))
    except localcider.SequenceFileParserException:
        # if we encounter a file parsing error just skip that sequence
        continue
    # take last digits of file name as pdb id
    pdbs.append(file[-4:])

# for each
for pdb, obj  in zip(pdbs, list_of_SeqObjs):
    seqlen = ("%s \t %i" % (pdb, obj.get_length()))
    fracexp = ("%s \t %.2f" % (pdb, obj.get_fraction_expanding()))
    fracchrg = ("%s \t %.2f" % (pdb, obj.get_FCR()))
    meanchrg = ("%s \t %.2f" % (pdb, obj.get_mean_net_charge()))
    fracdis = ("%s \t %.2f" % (pdb, obj.get_fraction_disorder_promoting()))
    hydrophob = ("%s \t %.2f" % (pdb, obj.get_mean_hydropathy()))
    phase = ("%s \t %i" % (pdb, obj.get_phasePlotRegion()))

    # print to file
    seqlenfile.write(seqlen)
    seqlenfile.write("\n")
    expfile.write(fracexp)
    expfile.write("\n")
    chrgfile.write(fracchrg)
    chrgfile.write("\n")
    mchrgfile.write(meanchrg)
    mchrgfile.write("\n")
    disfile.write(fracdis)
    disfile.write("\n")
    hydfile.write(hydrophob)
    hydfile.write("\n")
    phasefile.write(phase)
    phasefile.write("\n")
    
seqlenfile.close()
expfile.close()
chrgfile.close()
mchrgfile.close()
disfile.close()
hydfile.close()
phasefile.close()

