#
#proc select-residues { number_of_files } {
proc select-residues { FTstart FTend FTfileformat STstart STend STfileformat } {

	#
	# Reading the FTMap Files
	#
	set oi [molinfo list]
	set lastTopBeforeFTMap [lrange $oi [expr [llength $oi] - 1]  [expr [llength $oi] - 1]]

	set AlignRange "type CA and residue 0 to 798"
	for {set i $FTstart} {$i <= $FTend} {incr i} {
                set FTfilename [format $FTfileformat [expr $i]]
                puts "Reading file $FTfilename"
                mol new $FTfilename
                align [molinfo top] [molinfo index 0] $AlignRange
	}
	set oi [molinfo list]
	set lastTopAfterFTMap [lrange $oi [expr [llength $oi] - 1]  [expr [llength $oi] - 1]]

	set lFTMapResidues []
	for {set i [expr $lastTopBeforeFTMap + 0]} {$i <= $lastTopAfterFTMap} {incr i} {
  		mol top $i
		mol off $i
		set sel [atomselect $i "same residue as (within 3 of residuetype nothing) and chain A"]
        	foreach {j} [$sel get residue] {
			if { [lsearch $lFTMapResidues $j] == -1 } {
				lappend lFTMapResidues $j
			}
        	}
	}

	#
	# Setting the Protein to NewCartoon and Transparent
	#
	set active [expr $lastTopBeforeFTMap + 0]
	mol top $active
        mol on $active
	mol delrep 0 $active

        mol representation NewCartoon 0.3 10 4.5
	mol selection "all"
        mol material Transparent
        mol addrep top

	#
	# Setting the FTMap Representation
	#
	mol representation Licorice 0.3 10 10
        mol selection "residue $lFTMapResidues"
        mol color Name
        mol material Opaque
        mol addrep top


	#
	# Reading the STMap Files
	#
	set oi [molinfo list]
	set lastTopBeforeSTMap [lrange $oi [expr [llength $oi] - 1]  [expr [llength $oi] - 1]]

	set AlignRange "type CA and residue 0 to 798"
	for {set i $STstart} {$i <= $STend} {incr i} {
                set STfilename [format $STfileformat [expr $i]]
                puts "Reading file $STfilename"
                mol new $STfilename
                align [molinfo top] [molinfo index 0] $AlignRange
	}
	set oi [molinfo list]
	set lastTopAfterSTMap [lrange $oi [expr [llength $oi] - 1]  [expr [llength $oi] - 1]]

	set lSTMapResidues []
	for {set i [expr $lastTopBeforeSTMap + 0]} {$i <= $lastTopAfterSTMap} {incr i} {
  		mol top $i
		mol off $i
		set sel [atomselect $i "same residue as (within 3 of residuetype nothing) and chain A"]
        	foreach {j} [$sel get residue] {
			if { [lsearch $lSTMapResidues $j] == -1 } {
				lappend lSTMapResidues $j
			}
        	}
	}

 	#
	# Setting the STMap representation
	#
	set active [expr $lastTopBeforeFTMap + 0]
	mol top $active

	mol representation Licorice 0.3 10 10
        mol selection "residue $lSTMapResidues"
        mol color Name
        mol material Opaque
        mol addrep top

	#
	# Now working on the interception
	#
        set lBothResidues []
        foreach {i} $lFTMapResidues  {
        	if { [lsearch $lSTMapResidues $i] != -1 } {
                	lappend lBothResidues $i
                }
        }

        #
        # Setting the Interception representation
        #
        mol representation Licorice 0.3 10 10
        mol selection "residue $lBothResidues"
        mol color Name
        mol material Opaque
        mol addrep top
}
