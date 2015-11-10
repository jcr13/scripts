proc rmsf-color {infilename MolID} {

    if [catch {open $infilename r} infileid] {
	puts stderr "cannot open $infilename for reading"
    } else {
	set rmsf1 []
	set rmsf2 []
	set rmsf3 []
	set rmsf4 []
	set rmsf5 []
	set rmsf6 []
	foreach line [split [read $infileid] \n] {
	    if {[llength $line] == 0} {
		continue
	    } else {
		foreach {i} [lindex $line 1] {
		    if {$i <= 0.5000} {
			lappend rmsf1 [lindex $line 0]
		    }
		    if {$i >= 0.5001 && $i < 1.000} {
			lappend rmsf2 [lindex $line 0]
		    }
		    if {$i >= 1.0001 && $i < 1.5000} {
			lappend rmsf3 [lindex $line 0]
		    }
		    if {$i >= 1.5001 && $i < 2.000} {
			lappend rmsf4 [lindex $line 0]
		    } 
		    if {$i >= 2.0000 && $i < 2.5000} {
			lappend rmsf5 [lindex $line 0]
		    }
		    if {$i >= 2.5000} {
			lappend rmsf6 [lindex $line 0]
		    }
		    }
		}
	    }
	    mol top $MolID
	    mol rep NewCartoon 0.3 10 4.5
		mol selection "residue $rmsf1"
		mol color ColorID 0
		mol material Opaque
		mol addrep top
		####
		mol selection "residue $rmsf2"
		mol color ColorID 10
		mol material Opaque
		mol addrep top
		####
		mol selection "residue $rmsf3"
		mol color ColorID 7
		mol material Opaque
		mol addrep top
		####
		mol selection "residue $rmsf4"
		mol color ColorID 4
		mol material Opaque
		mol addrep top
		####
		mol selection "residue $rmsf5"
		mol color ColorID 3
		mol material Opaque
		mol addrep top
		####
                mol selection "residue $rmsf6"
                mol color ColorID 1
                mol material Opaque
                mol addrep top  
	close $infileid
    }
}
