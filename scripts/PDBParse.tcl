
#	This script parses a multiframe PDB file into some number of files, each consisting of a single frame.
#	To use this script, the PDB file of interest must already be loaded into VMD.
#
#	This script will prompt the user for the first and last frames to be saved as individual files.
#	All files between these values will be saved.
#
#	The script will prompt the user for an output name.
#	For instance, if the output files should be titled Sample0001.pdb, Sample0002.pdb, etc.,
#	the input should be:
#	Sample%04d.pdb
#
#	Example usage of the script:
#	source PDBParse.tcl
#	mol new clusters.pdb
#	parse top
#	0
#	5
#	Sample%d.pdb
#
#	The script will save the first six frames of clusters.pdb to Sample0.pdb, Sample1.pdb, ... Sample5.pdb.




proc parse {molecule} {

#mol new $mainfile type {pdb} first 0 last 100 step 1 waitfor 1
#puts "$mainfile loaded."

puts "I see that molecule $molecule has [molinfo top get numframes] frames."
puts -nonewline "What is the first frame to grab? "
set beg [gets stdin]
puts -nonewline "What is the last frame to grab? "
set end [gets stdin]
puts -nonewline "What should the output files be named? \nNote: use %d as a variable for frame numbers. \nTo set a fixed number of digits n, use %0nd.\nOutput file names? "
set fileformat [gets stdin]

for {set i $beg} {$i <= $end} {incr i} {
puts "Beginning for loop iteration [expr $i - $beg]"
	set filename [format $fileformat [expr $i]]
#	atomselect $molecule "protein"
puts "Filename is $filename"
	set sel [atomselect top "chain A"]
	animate write pdb $filename beg $i end $i skip 1 sel $sel $molecule
puts "Ending for loop iteration [expr $i - $beg]"
}

}
