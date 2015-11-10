#loads pdbs to be colored the same as PDHSV.tcl colors ftmap spheres
proc color_cluster_load { filename number_of_files } {

set j [expr $number_of_files + 1]
for {set i 1} {$i<$j} {incr i} {
	mol new $filename-$i.pdb
}

mol rep NewCartoon
mol color Molecule

for {set i 0} {$i<$number_of_files} {incr i} {
        mol delrep 0 $i 
	mol addrep $i
}

color scale method RGB

for {set i 0} {$i<$number_of_files} {incr i} {
	set Num [expr 33 + {1023 * $i/$number_of_files}]
	color Molecule $i $Num
}
}
