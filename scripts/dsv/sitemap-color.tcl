proc sitemap-color { start end filename } {

for {set i $start} {$i<[expr $end +1]} {incr i} {
        mol new $filename-$i-merged.pdb
}

for {set l 0} {$l<$end} {incr l} {
	set sel [atomselect $l "chain X"]
	volmap density $sel -res 0.3 -weight none -mol $l
	mol rep Isosurface 0.5 0 0 0 1 1
	mol material Opaque
	mol color Molecule
}

for {set j 0} {$j<$end} {incr j} {
        mol delrep 0 $j 
        mol addrep $j
}

color scale method RGB

for {set k 0} {$k<$end} {incr k} {
        set Num [expr 33 + {1023 * $k/$end}]
        color Molecule $k $Num
}
}
