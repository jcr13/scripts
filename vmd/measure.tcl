proc measure-distance { num_of_mols datfile} {

    set outfile [open $datfile w]
        for {set i 0} {$i<$num_of_mols} {incr i} {
	    set sel1 [atomselect $i "resid 50 and type CA"]
	    set sel2 [atomselect $i "resid 131 and type CA"]
	    set com1 [measure center $sel1 weight mass]
	    set com2 [measure center $sel2 weight mass]
	    set length($i.r) [veclength [vecsub $com1 $com2]]
	    puts $outfile "$i $length($i.r)"
    	}
    close $outfile
}
