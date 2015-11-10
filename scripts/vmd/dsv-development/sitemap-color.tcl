proc sitemap-color { STstart STend STfileformat } {

for {set i $STstart} {$i<[expr $STend +1]} {incr i} {
        mol new $STfileformat-$i-merged.pdb
}

for {set l 0} {$l<$STend} {incr l} {
	set sel [atomselect $l "chain X"]
	volmap density $sel -res 0.3 -weight none -mol $l
	mol rep Isosurface 0.5 0 0 0 1 1
	mol material Opaque
	mol color Molecule
}

for {set j 0} {$j<$STend} {incr j} {
        mol delrep 0 $j 
        mol addrep $j
}

color scale method RGB

for {set k 0} {$k<$STend} {incr k} {
        set Num [expr 33 + {1023 * $k/$STend}]
        color Molecule $k $Num
}
}
