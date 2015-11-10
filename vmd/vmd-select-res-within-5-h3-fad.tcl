#load all holo-md structures, then this finds residues within 5 of fad or h3
proc within-fad-h3 { number_of_files } {

#represent residues in licorice based on name
mol rep licorice
mol color name

#for holo-md-bound this eliminates active site residues and h3 peptide
mol selection same residue as (within 5 of resname FAD or chain D)

#add the representation
for {set i 0} {$i<$number_of_files} {incr i} {
	mol addrep $i
}

#save a pdb file for each with the residues
for {set k 0} {$k<$number_of_files} {incr k} {
	[atomselect $k "same residue as (within 5 of resname FAD or chain D)"] writepdb residues-within-5-of-fad-h3-[expr $k + 1].pdb
}

}
