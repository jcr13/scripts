#!/usr/bin/env python

# POVME is released under the GNU General Public License (see http://www.gnu.org/licenses/gpl.html).
# If you have any questions, comments, or suggestions, please don't hesitate to contact me,
# Jacob Durrant, at jdurrant [at] ucsd [dot] edu.
#
# If you use POVME in your work, please cite Durrant, J. D., C. A. de Oliveira, et al.
#    (2011). "POVME: An algorithm for measuring binding-pocket volumes." J Mol Graph
#    Model 29(5): 773-776.

import math
import sys
import time

version = "1.1.0"

start_time = time.time()

def reference(before=""):
    print before + "If you use POVME in your research, please cite the following reference:"
    print before + "  Durrant, J. D., C. A. de Oliveira, et al. (2011). \"POVME: An algorithm"
    print before + "  for measuring binding-pocket volumes.\" J Mol Graph Model 29(5): 773-776."


def therange(start, end, step):
    arange = []
    delta = end - start
    numsteps = delta / step + 1
    for i in range(0,int(numsteps)):
        if start + i * step <= end:
            arange.append(start + i * step)
        
    return arange

def format_num(num):
    astr = "%.3f" % num
    while len(astr) < 7:
        astr = ' ' + astr
    return astr

def convert_atomname_to_element(atomname):
    element = atomname
    element = element.replace("0","")
    element = element.replace("1","")
    element = element.replace("2","")
    element = element.replace("3","")
    element = element.replace("4","")
    element = element.replace("5","")
    element = element.replace("6","")
    element = element.replace("7","")
    element = element.replace("8","")
    element = element.replace("9","")
    element = element[:1]
    return element

def get_vdw(element):
        ans = 1.0 # the default
        if element=="H":
                ans = 1.2
        if element=="C":
                ans = 1.7
        if element=="N":
                ans = 1.55
        if element=="O":
                ans = 1.52
        if element=="F":
                ans = 1.47
        if element=="P":
                ans = 1.8
        if element=="S":
                ans = 1.8
        return ans

class point:
    x=99999.0
    y=99999.0
    z=99999.0
    
    def __init__ (self, x, y ,z):
        self.x = x
        self.y = y
        self.z = z

    def print_coors(self):
        print str(self.x)+"\t"+str(self.y)+"\t"+str(self.z)
        
    def snap(self,reso): # snap the point to a grid
        self.x = round(self.x / reso) * reso
        self.y = round(self.y / reso) * reso
        self.z = round(self.z / reso) * reso
        
    def dist_to(self,apoint):
        return math.sqrt(math.pow(self.x - apoint.x,2) + math.pow(self.y - apoint.y,2) + math.pow(self.z - apoint.z,2))

    def description(self):
        return str(self.x) + " " + str(self.y) + " " + str(self.z)

class region:

    def __init__(self):
        self.center = point(9999.9, 9999.9, 9999.9)
        self.radius = 9999.9 # in case the region is a sphere
        self.box_dimen = point(9999.9, 9999.9, 9999.9) # in case the region is a box
        
        self.region_type = "SPHERE" # could also be BOX

    def volume(self):
        vol = 0.0
        if self.region_type == "SPHERE":
            vol = (4.0 / 3.0) * math.pi * math.pow(self.radius,3)
        elif self.region_type == "BOX":
            vol = self.box_dimen.x * self.box_dimen.y * self.box_dimen.z
        return vol
    
    def point_in_region(self, point, padding):
        #print point.x, point.y, point.z # ******
        #point.print_coors() # It's all 0
        response = False
        if self.region_type == "SPHERE":
            dist = math.sqrt(math.pow(point.x-self.center.x,2) + math.pow(point.y-self.center.y,2) + math.pow(point.z-self.center.z,2))
            if dist <= self.radius + padding:
                response = True
        elif self.region_type == "BOX":
            x_min = self.center.x - self.box_dimen.x/2 - padding
            x_max = self.center.x + self.box_dimen.x/2 + padding
            y_min = self.center.y - self.box_dimen.y/2 - padding
            y_max = self.center.y + self.box_dimen.y/2 + padding
            z_min = self.center.z - self.box_dimen.z/2 - padding
            z_max = self.center.z + self.box_dimen.z/2 + padding


            #print x_min, x_max, y_min, y_max, z_min,z_max

            if point.x >= x_min and point.x <= x_max and point.y >= y_min and point.y <= y_max and point.z >= z_min and point.z <= z_max:
                response = True
        
        return response
    
    def print_out(self):
        self.center.print_coors()
        print self.radius
        self.box_dimen.print_coors()
        print self.region_type
        
    def points_set(self, reso):
        points = []
        if self.region_type == "BOX":
            #self.center = point(9999.9, 9999.9, 9999.9)
            #self.box_dimen
            #print self.center.print_coors()
            for x in therange(self.center.x - self.box_dimen.x / 2,self.center.x + self.box_dimen.x / 2, reso):
                for y in therange(self.center.y - self.box_dimen.y / 2, self.center.y + self.box_dimen.y / 2, reso):
                    for z in therange(self.center.z - self.box_dimen.z / 2,self.center.z + self.box_dimen.z / 2, reso):
                        thepoint = point(x,y,z)
                        thepoint.snap(reso)
                        #thepoint.print_coors()
                        points.append(thepoint)
        elif self.region_type == "SPHERE":
            for x in therange(self.center.x - self.radius,self.center.x + self.radius, reso):
                for y in therange(self.center.y - self.radius, self.center.y + self.radius, reso):
                    for z in therange(self.center.z - self.radius,self.center.z + self.radius, reso):
                        thepoint = point(x,y,z)
                        thepoint.snap(reso)
                        if self.point_in_region(thepoint,0): # padding always 0 for inclusion objects
                            points.append(thepoint)
        return points


class atom:
        
    def __init__ (self):
        self.atomname = ""
        self.residue = ""
        self.coordinates = point(99999, 99999, 99999)
        self.undo_coordinates = point(99999, 99999, 99999)
        self.element = ""
        self.PDBIndex = ""
        self.line=""
        self.IndeciesOfAtomsConnecting=[]
        
    def ReadPDBLine(self, Line):
        self.line = Line
        self.atomname = Line[11:16].strip()
        
        if len(self.atomname)==1:
            self.atomname = self.atomname + "  "
        elif len(self.atomname)==2:
            self.atomname = self.atomname + " "
        elif len(self.atomname)==3:
            self.atomname = self.atomname + " " # This line is necessary for babel to work, though many PDBs in the PDB would have this line commented out
        
        self.coordinates = point(float(Line[30:38]), float(Line[38:46]), float(Line[46:54]))
        
        if len(Line) >= 79:
            self.element = Line[76:79].strip().upper() # element specified explicitly at end of life
        elif self.element == "": # try to guess at element from name
            two_letters = self.atomname[0:2].strip().upper()
            if two_letters=='BR':
                self.element='BR'
            elif two_letters=='CL':
                self.element='CL'
            elif two_letters=='BI':
                self.element='BI'
            elif two_letters=='AS':
                self.element='AS'
            elif two_letters=='AG':
                self.element='AG'
            elif two_letters=='LI':
                self.element='LI'
            elif two_letters=='HG':
                self.element='HG'
            elif two_letters=='MG':
                self.element='MG'
            elif two_letters=='RH':
                self.element='RH'
            elif two_letters=='ZN':
                self.element='ZN'
            else: #So, just assume it's the first letter.
                self.element = self.atomname[0:1].strip().upper()
                
        # Any number needs to be removed from the element name
        self.element = self.element.replace('0','')
        self.element = self.element.replace('1','')
        self.element = self.element.replace('2','')
        self.element = self.element.replace('3','')
        self.element = self.element.replace('4','')
        self.element = self.element.replace('5','')
        self.element = self.element.replace('6','')
        self.element = self.element.replace('7','')
        self.element = self.element.replace('8','')
        self.element = self.element.replace('9','')

        self.PDBIndex = Line[6:12].strip()
        self.residue = Line[16:20]
        if self.residue.strip() == "": self.residue = " MOL"

    def CreatePDBLine(self):

        #if len(self.atomname) > 1: self.atomname = self.atomname[:1].upper() + self.atomname[1:].lower()

        output = "ATOM "
        #output = output + str(index).rjust(6) + self.atomname.rjust(5) + self.residue.rjust(4)
        output = output + self.PDBIndex.rjust(6) + self.atomname.rjust(5) + self.residue.rjust(4)
        output = output + ("%.3f" % self.coordinates.x).rjust(18)
        output = output + ("%.3f" % self.coordinates.y).rjust(8)
        output = output + ("%.3f" % self.coordinates.z).rjust(8)
        output = output + self.element.rjust(24) # + "   " + str(uniqueID) #This last part must be removed
        return output

    
class PDB:

    def __init__ (self):
        self.AllAtoms={}

    def LoadPDB(self, FileName, IncludeRegion, padding, UseRegion = True):

        autoindex = 1

        self.__init__()
        
        # Now load the file into a list
        file = open(FileName,"r")
        lines = file.readlines()
        file.close()
        
        for t in range(0,len(lines)):
            line=lines[t]
            if len(line) >= 7:
                if line[0:5]=="ATOM " or line[0:7]=="HETATM ": # Load atom data (coordinates, etc.)
                    TempAtom = atom()
                    TempAtom.ReadPDBLine(line)
                    
                    if UseRegion == True:
                        #TempAtom.coordinates.print_coors()
                        #print IncludeRegion.region_type
                        #IncludeRegion.center.print_coors()
                        #IncludeRegion.box_dimen.print_coors()
                        #print "***"
                        if IncludeRegion.point_in_region(TempAtom.coordinates, 0): #2*padding + 1):
                            self.AllAtoms[int(TempAtom.PDBIndex)] = TempAtom
                    else:
                        self.AllAtoms[autoindex] = TempAtom # because points files have no indecies
                        autoindex = autoindex + 1
                    
    def print_out_info(self):
        for index in self.AllAtoms:
            print self.AllAtoms[index].CreatePDBLine()

class ConfigFile:
    
    entities = []
    
    def __init__ (self, FileName):
        
        f = open(FileName,'r')
        lines = f.readlines()
        f.close()
        
        for line in lines:
            line = line.strip()

            # replace ; and , and : with space
            line = line.replace(',',' ')

            # replace ; and , and : with space
            line = line.replace(';',' ')

            # replace ; and , and : with space
            line = line.replace(':',' ')

            # replace ; and , and : with space
            line = line.replace("\t",' ')
            
            # now strip string
            line = line.strip()

            # now, replace double spaces with one space
            while '  ' in line:
                line = line.replace('  ',' ')
                
            # Now split the thing
            line = line.split(' ',1)

            # now, make it upper case
            line[0] = line[0].upper()
            
            self.entities.append(line)
    
# Load the configuration file

if len(sys.argv) == 1:
        print "\nPOVME " + version
        print "\nPlease specify the input file from the command line!\n\nExample: python POVME.py input_file.ini\n"
        reference()
        print ""
        sys.exit()

config = ConfigFile(sys.argv[1])

# Process the config file
PDBFileName = "" # default

grid_spacing = 0.5 # default

padding = 1.09 # default is VDW radius of hydrogen

IncludeRegions = []

ExcludeRegions = []

OutputReceptor = "FALSE" # default

CalculateVolumeOf = "POCKET" # default # can also be MOLECULE

SavePointsFilename = '' # default

LoadPointsFilename = '' # default

Contiguous = "FALSE"
ContiguousSeedRegions = []
ContiguousPointsCriteria = 4

reference("REMARK ")
print "REMARK "

for entity in config.entities:
    if entity[0] == "INCLUSIONSPHERE":
        Include = region()
        items = entity[1].split(' ')
        Include.center.x = float(items[0])
        Include.center.y = float(items[1])
        Include.center.z = float(items[2])
        Include.radius = float(items[3])
        Include.region_type = "SPHERE"
        IncludeRegions.append(Include)

        print "REMARK Inclusion sphere at (" + items[0] + ", " + items[1] + ", " + items[2] + "), radius = " + items[3]
    elif entity[0] == "INCLUSIONBOX":
        Include = region()
        items = entity[1].split(' ')
        Include.center.x = float(items[0])
        Include.center.y = float(items[1])
        Include.center.z = float(items[2])
        Include.box_dimen.x = float(items[3])
        Include.box_dimen.y = float(items[4])
        Include.box_dimen.z = float(items[5])
        Include.region_type = "BOX"
        IncludeRegions.append(Include)

        print "REMARK Inclusion box centered at (" + items[0] + ", " + items[1] + ", " + items[2] + ") with x,y,z dimensions of (" + items[3] + ", " + items[4] + ", " + items[5] + ")"

    if entity[0] == "CONTIGUOUSSEEDSPHERE":
        Contig = region()
        items = entity[1].split(' ')
        Contig.center.x = float(items[0])
        Contig.center.y = float(items[1])
        Contig.center.z = float(items[2])
        Contig.radius = float(items[3])
        Contig.region_type = "SPHERE"
        ContiguousSeedRegions.append(Contig)

        print "REMARK Contiguous seed sphere at (" + items[0] + ", " + items[1] + ", " + items[2] + "), radius = " + items[3]
    elif entity[0] == "CONTIGUOUSSEEDBOX":
        Contig = region()
        items = entity[1].split(' ')
        Contig.center.x = float(items[0])
        Contig.center.y = float(items[1])
        Contig.center.z = float(items[2])
        Contig.box_dimen.x = float(items[3])
        Contig.box_dimen.y = float(items[4])
        Contig.box_dimen.z = float(items[5])
        Contig.region_type = "BOX"
        ContiguousSeedRegions.append(Contig)

        print "REMARK Contiguous seed box centered at (" + items[0] + ", " + items[1] + ", " + items[2] + ") with x,y,z dimensions of (" + items[3] + ", " + items[4] + ", " + items[5] + ")"

    elif entity[0] == "GRIDSPACING":
        grid_spacing = float(entity[1])
        print "REMARK grid_spacing = " + entity[1]
    elif entity[0] == "CONTIGUOUSPOINTSCRITERIA":
        ContiguousPointsCriteria = float(entity[1])
        print "REMARK Contiguous points criteria = " + entity[1]
    elif entity[0] == "PADDING":
        padding = float(entity[1])
        print "REMARK padding = " + entity[1]
    elif entity[0] == "PDBFILENAME":
        PDBFileName = entity[1]
        print "REMARK PDBFileName = " + entity[1]
    elif entity[0] == "OUTPUTRECEPTOR":
        OutputReceptor = entity[1].upper()
        if OutputReceptor == "YES": # so it can be TRUE or YES
            OutputReceptor = "TRUE"
        print "REMARK OutputReceptor = " + entity[1]
    elif entity[0] == "CONTIGUOUS":
        Contiguous = entity[1].upper()
        if Contiguous == "YES": # so it can be TRUE or YES
            Contiguous = "TRUE"
        print "REMARK Contiguous = " + entity[1]
    elif entity[0] == "EXCLUSIONSPHERE":
        #print IncludeRegion.center.x
        Exclude = region()
        items = entity[1].split(' ')
        Exclude.center.x = float(items[0])
        Exclude.center.y = float(items[1])
        Exclude.center.z = float(items[2])
        Exclude.radius = float(items[3])
        Exclude.region_type = "SPHERE"
        ExcludeRegions.append(Exclude)
        #print IncludeRegion.center.x
        print "REMARK Exclusion sphere at (" + items[0] + ", " + items[1] + ", " + items[2] + "), radius = " + items[3]
    elif entity[0] == "EXCLUSIONBOX":
        Exclude = region()
        items = entity[1].split(' ')
        Exclude.center.x = float(items[0])
        Exclude.center.y = float(items[1])
        Exclude.center.z = float(items[2])
        Exclude.box_dimen.x = float(items[3])
        Exclude.box_dimen.y = float(items[4])
        Exclude.box_dimen.z = float(items[5])
        Exclude.region_type = "BOX"
        ExcludeRegions.append(Exclude)
        print "REMARK Exclusion box centered at (" + items[0] + ", " + items[1] + ", " + items[2] + ") with x,y,z dimensions of (" + items[3] + ", " + items[4] + ", " + items[5] + ")"
    elif entity[0] == "CALCULATEVOLUMEOF":
        CalculateVolumeOf = entity[1].upper().strip()
        print "REMARK CalculateVolumeOf = " + CalculateVolumeOf
    elif entity[0] == "SAVEPOINTSFILENAME":
        SavePointsFilename = entity[1].strip()
        print "REMARK SavePointsFileName = " + SavePointsFilename
    elif entity[0] == "LOADPOINTSFILENAME":
        LoadPointsFilename = entity[1].strip()
        print "REMARK LoadPointsFileName = " + LoadPointsFilename

# now, we need to identify the points to consider. They must in the inclusion regions but not in the exclusion regions.
AllPoints = []

# First, if there's a point file to load, load it
if LoadPointsFilename!='':
    # Make a humongoid sphere. PDB is sure to be in this region
    pdb_pts = PDB()
    pdb_pts.LoadPDB(LoadPointsFilename, region(), 0, False) # just load in the points
    for index in pdb_pts.AllAtoms.iterkeys():
        an_atom = pdb_pts.AllAtoms[index]
        AllPoints.append(an_atom.coordinates)

for Included in IncludeRegions:
    pts = Included.points_set(grid_spacing)
    for pt in pts:
        # see if the point is already in the master list
        doinclude = True
        for pt2 in AllPoints:
            if pt.x == pt2.x and pt.y == pt2.y and pt.z == pt2.z:
                doinclude = False
                break
            elif abs(pt2.x - pt.x) < 0.01: # But there could be rounding errors. Thought to be faster this way that doing dist cal directly, because most points will not satisfy.
                if abs(pt2.z - pt.y) < 0.01:
                    if abs(pt2.z - pt.z) < 0.01:
                        if pt2.dist_to(pt) < 0.01: # could be some rounding error. So min resolution should be 0.01
                            doinclude = False
                            break
        
        if doinclude == True:
            AllPoints.append(pt)

# now go back and remove points from the exclusion regions
for Excluded in ExcludeRegions:
    for index in range(len(AllPoints)-1,0,-1):
        pt = AllPoints[index]
        if Excluded.point_in_region(pt, 0.0): # padding is always 0 for these regions
            AllPoints.pop(index)

if SavePointsFilename!='':
    file = open(SavePointsFilename,'w')
    for pt in AllPoints:
        astr = "ATOM      1  X     X X   1     XXX.XXX YYY.YYY ZZZ.ZZZ  1.00  0.00"
        astr = astr.replace("XXX.XXX", format_num(pt.x))
        astr = astr.replace("YYY.YYY", format_num(pt.y))
        astr = astr.replace("ZZZ.ZZZ", format_num(pt.z))
        file.write(astr + "\n")
    file.close()
    print "REMARK Fill points saved to " + SavePointsFilename
    print "REMARK Program terminated, no protein pdb file will be loaded or analyzed."
    print "REMARK Remove the SavePointsFileName parameter from the input file to proceed with analysis..."
    sys.exit(0)

min_x = 9999999.0
min_y = 9999999.0
min_z = 9999999.0
max_x = -9999999.0
max_y = -9999999.0
max_z = -9999999.0

#print len(AllPoints)

for pt in AllPoints:
    if pt.x > max_x: max_x = pt.x
    if pt.y > max_y: max_y = pt.y
    if pt.z > max_z: max_z = pt.z
    if pt.x < min_x: min_x = pt.x
    if pt.y < min_y: min_y = pt.y
    if pt.z < min_z: min_z = pt.z

# The next task is to remove all points that are too close to protein atoms

# First, let's load in the pdb
# we need to define the region to be considered.

PDBRegion = region()
PDBRegion.center.x = (min_x + max_x) / 2
PDBRegion.center.y = (min_y + max_y) / 2
PDBRegion.center.z = (min_z + max_z) / 2

PDBRegion.box_dimen.x = max_x - min_x + 2 * padding + 1
PDBRegion.box_dimen.y = max_y - min_y + 2 * padding + 1
PDBRegion.box_dimen.z = max_z - min_z + 2 * padding + 1
PDBRegion.region_type = "BOX"

#pts = PDBRegion.points_set(0.5)

pdb = PDB()
pdb.LoadPDB(PDBFileName, PDBRegion, 0)

PDBLines = ""
point_kept = 0
for index in range(len(AllPoints)-1,0,-1):
    pt = AllPoints[index]
    # now we need to see if this point is within the VDW radius of any protein atom
    if CalculateVolumeOf == "POCKET":
        okay = True
    else: # So it's molecule
        okay = False

    for atom_index in pdb.AllAtoms:

        an_atom = pdb.AllAtoms[atom_index]

        element = convert_atomname_to_element(an_atom.atomname)
        dist2 = pt.dist_to(an_atom.coordinates)
        vdw = get_vdw(element)
        vdw = vdw + padding 
        
        if CalculateVolumeOf == "POCKET":
            if vdw > dist2:
                okay = False
                break
        else: # so it's actually MOLECULE
            if vdw > dist2:
                okay = True
                break

    if okay == False:
        AllPoints.pop(index)

# Now, enforce contiguity if needed

if Contiguous == "TRUE":
    contig_points = {}
    
    # First, get points within the contiguous seed regions
    config_min_x = 99999999.0
    config_min_y = 99999999.0
    config_min_z = 99999999.0
    config_max_x = -99999999.0
    config_max_y = -99999999.0
    config_max_z = -99999999.0
    
    for index in range(len(AllPoints)-1,0,-1):
        pt = AllPoints[index]
        pt_in_region = False
        for region in ContiguousSeedRegions: # check if the point is in any of the seed regions
            if region.point_in_region(pt,0): # using 0 padding
                pt_in_region = True
                break
        if pt_in_region == True: # It is, so add it to the contig_points list, deletion original AllPoints
            contig_points[pt.description()] = pt
            if pt.x < config_min_x: config_min_x = pt.x
            if pt.y < config_min_y: config_min_y = pt.y
            if pt.z < config_min_z: config_min_z = pt.z
            
            if pt.x > config_max_x: config_max_x = pt.x
            if pt.y > config_max_y: config_max_y = pt.y
            if pt.z > config_max_z: config_max_z = pt.z
            
            AllPoints.pop(index)

    # now go through each point in contig_points and add points from AllPoints that are clos.
    
    radius = grid_spacing * 1.01 * math.sqrt(2) # to count kiddy-corner points too
    change = True
    while change == True:
        change = False
        # go through each of the points in the pdb
        atoms_to_remove = []
        for index in range(len(AllPoints)-1,0,-1):
            pt_coor = AllPoints[index]
            
            if pt_coor.x < config_max_x + radius * 1.1 and pt_coor.y < config_max_y + radius * 1.1 and pt_coor.z < config_max_z + radius * 1.1 and pt_coor.x > config_min_x - radius * 1.1 and pt_coor.y > config_min_y - radius * 1.1 and pt_coor.z > config_min_z - radius * 1.1:
            
                if not contig_points.has_key(pt_coor.description()):
                
                    # count the number of points from the growing list that are within reso * 1.01 of this atom
                    count = 0
                    for pt in contig_points.itervalues():
                        if pt.dist_to(pt_coor) < radius: count = count + 1 # to get kiddy-corner too
                        if count >= ContiguousPointsCriteria: break
                
                    if count >= ContiguousPointsCriteria: #So there's two points close by
                        contig_points[pt_coor.description()] = pt_coor
                        
                        if pt_coor.x < config_min_x: config_min_x = pt_coor.x
                        if pt_coor.y < config_min_y: config_min_y = pt_coor.y
                        if pt_coor.z < config_min_z: config_min_z = pt_coor.z
                        
                        if pt_coor.x > config_max_x: config_max_x = pt_coor.x
                        if pt_coor.y > config_max_y: config_max_y = pt_coor.y
                        if pt_coor.z > config_max_z: config_max_z = pt_coor.z
                        
                        AllPoints.pop(index)
                        change = True
                        
    # now, the points in contig_points are the ones to keep. Transfer these over to AllPoints
    AllPoints = []
    for pt in contig_points: AllPoints.append(contig_points[pt])
                    
# Now build string of atom coordinates for pdb file

for pt in AllPoints:
    astr = "ATOM      1  X     X X   1     XXX.XXX YYY.YYY ZZZ.ZZZ  1.00  0.00"
    astr = astr.replace("XXX.XXX", format_num(pt.x))
    astr = astr.replace("YYY.YYY", format_num(pt.y))
    astr = astr.replace("ZZZ.ZZZ", format_num(pt.z))
    
    PDBLines = PDBLines + astr + "\n"
    if OutputReceptor == "TRUE":
        PDBLines = PDBLines + "TER\n"

vol = len(AllPoints) * math.pow(grid_spacing,3)
print "REMARK Volume = " + repr(vol) + " Cubic Angtroms"
print "REMARK Execution time = " + str(time.time()-start_time) + " sec"
if OutputReceptor == "TRUE":
    pdb.print_out_info()
    print "TER"
print PDBLines
