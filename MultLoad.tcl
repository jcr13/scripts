
#NOTE: To add check for residues within X of a particular chain,
#	set sel [atomselect top "chain A and within $X of chain $particular"]
#	set res [lsort -ascii -unique [$sel get residue]]



proc align {new old AlignRange} {

	puts "Aligning molecule $new to molecule $old."
	puts "The paramaters for the alignment are:"
	puts $AlignRange

	set sel1 [atomselect $new $AlignRange]
	set sel2 [atomselect $old $AlignRange]
	set start_rmsd [measure rmsd $sel1 $sel2]
	set move_sel [atomselect $new all]
	set T_matrix [measure fit $sel1 $sel2]
	$move_sel move $T_matrix
	set end_rmsd [measure rmsd $sel1 $sel2]

	puts "Alignment begun with RMSD: $start_rmsd"
	puts "Alignment complete with RMSD: $end_rmsd"
	
	$sel1 delete
	$sel2 delete
	$move_sel delete

}


proc LoadGraphics {filename} {

	puts "Reading protein model from $filename."
	mol new $filename
	mol modselect 0 top protein
	
	#Edit the following lines to change the graphical representation of the protein model.
	mol modstyle 0 top Surf
	mol modmaterial 0 top Ghost
	mol color Name
	mol representation Lines 1
	color Display Background white
	mol addrep top
	mol modselect 1 top "chain C"
	display rendermode GLSL
	display projection Orthographic
	color scale method RGB
	axes location off

}


# overproc from tcl wiki:
# http://www2.tcl.tk/20409
proc overproc {n p b} {
      # define dispatcher
      uplevel [list proc $n {args} [string map [list %N $n] {
          uplevel [list "%N with [llength $args] args"] $args
      }]]
      # define the function itself
      uplevel [list proc "$n with [llength $p] args" $p $b]
}


overproc multload {FTstart FTend FTfileformat STstart STend STfileformat} {
	
	#These parameters can/should be edited when needed.
	#
	#Note that currently, MaxSphereSize needs to be greater than or equal to SpheresToDisplay.
	#
	#Change iValue to edit the isovalue for the isosurface of the volmap generated for Sitemap
	#results.  A smaller value will draw larger volumes, with a value of 0 giving an infinite size.
	#It is recommended that the iValue be set to around 0.3 to 0.5.
	set AlignRange "type CA and residue 5 to 200"
	set MaxSphereSize 5.0
	set SpheresToDisplay 3
	set SphereMaterial EdgyGlass
	set iValue 0.5

	set FTfilename [format $FTfileformat [expr $FTstart]]
	puts "No initial template given.  Default template used."
	LoadGraphics $FTfilename
	
	#This is used for determining sphere colors.  Essentially, dividing the color scale would
	#require dividing by 0 if there was only one FTCluster.  This line keeps that from breaking.
	set FTNumFiles [expr {($FTend - $FTstart)? ($FTend - $FTstart):1 }]
	set FTCurFile 0
	
	#This for loop loads the FTClusters
	for {set i $FTstart} {$i <= $FTend} {incr i} {
		set FTfilename [format $FTfileformat [expr $i]]
		puts "Reading file $FTfilename"
		mol new $FTfilename
		align [molinfo top] [molinfo index 0] $AlignRange
		
		graphics top materials on
		graphics top material $SphereMaterial
		#This divides the color scale into increments.
		set FTCNum [expr 33 + { 1023 * $FTCurFile / $FTNumFiles}]
		incr FTCurFile
		graphics top color $FTCNum
		
		set sel [atomselect top all]
		
		set chains [lsort -ascii -unique [$sel get chain]]
		#puts "The current chains are $chains"
		set NumChains [llength $chains]
		
		for {set j 0} {$j < $SpheresToDisplay} {incr j} {
			set Current [lindex $chains [expr $NumChains - 1 - $j]]
			set sel [atomselect top "chain $Current"]
			set M [measure center $sel]
			#The current definition of R is a little sloppy- it needs to be reworked if
			#SpheresToDisplay >= MaxSphereSize
			set R [expr $MaxSphereSize - $j]
			graphics top sphere $M radius $R resolution 250
		}
		
		mol modselect 0 top none
		
	}
	
	#This for loop loads the Sitemap surfaces
	for {set i $STstart} {$i <= $STend} {incr i} {
		set STfilename [format $STfileformat [expr $i]]
		puts "Reading file $STfilename"
		mol new $STfilename
		align [molinfo top] [molinfo index 0] $AlignRange
		
		set sel [atomselect top "chain X"]
		volmap density $sel -res 0.3 -weight none -mol top
		mol representation Isosurface $iValue 0 0 0 1 1
		mol selection all
		mol material Opaque
		mol color ColorID $i
		mol addrep top
		mol delrep 0 top
		mol modcolor 0 top ColorID $i
	}
	
	$sel delete
}

overproc multload {start end fileformat} {
	
	#These parameters can/should be edited when needed.
	#
	#Note that currently, MaxSphereSize needs to be greater than or equal to SpheresToDisplay.

	set AlignRange "type CA and residue 5 to 200"
	set MaxSphereSize 5.0
	set SpheresToDisplay 5
	set SphereMaterial EdgyGlass
	
	set filename [format $fileformat [expr $start]]
	puts "No initial template given.  Default template used."
	LoadGraphics $filename

	set NumFiles [expr {($end - $start)? ($end - $start):1 }]
	set CurFile 0
	
	#This loop draws spheres affiliated with FTClusters.
	for {set i $start} {$i <= $end} {incr i} {
		set filename [format $fileformat [expr $i]]
		puts "Reading file $filename"
		mol new $filename

		graphics top materials on
		graphics top material $SphereMaterial
		set CNum [expr 33 + { 1023 * $CurFile / $NumFiles }]
		incr CurFile
		graphics top color $CNum

		set sel [atomselect top all]

		set chains [lsort -ascii -unique [$sel get chain]]
		set NumChains [llength $chains]
		
		for {set j 0} {$j < $SpheresToDisplay} {incr j} {
			set Current [lindex $chains [expr $NumChains -1 - $j]]
			set sel [atomselect top "chain $Current"]
			set M [measure center $sel]
			set R [expr $MaxSphereSize - $j]
			graphics top sphere $M radius $R resolution 250
		}
		
		mol modselect 0 top none

	}

	$sel delete

}


overproc multload {start end fileformat template} {
	
	#These parameters can/should be edited when needed.
	#
	#Note that currently, MaxSphereSize needs to be greater than or equal to SpheresToDisplay.

	set AlignRange "type CA and residue 5 to 200"
	set MaxSphereSize 5.0
	set SpheresToDisplay 5
	set SphereMaterial EdgyGlass
	
	set filename [format $fileformat [expr $start]]
	puts "Using template $template"
	LoadGraphics $template
	set TemplateNum [molinfo top]

	set NumFiles [expr {($end - $start)? ($end - $start):1 }]
	set CurFile 0
	
	#This loop draws spheres affiliated with FTClusters.
	for {set i $start} {$i <= $end} {incr i} {
		set filename [format $fileformat [expr $i]]
		puts "Reading file $filename"
		mol new $filename
		align top $TemplateNum $AlignRange

		graphics top materials on
		graphics top material $SphereMaterial
		set CNum [expr 33 + { 1023 * $CurFile / $NumFiles }]
		incr CurFile
		graphics top color $CNum

		set sel [atomselect top all]

		set chains [lsort -ascii -unique [$sel get chain]]
		set NumChains [llength $chains]
		
		for {set j 0} {$j < $SpheresToDisplay} {incr j} {
			set Current [lindex $chains [expr $NumChains -1 - $j]]
			set sel [atomselect top "chain $Current"]
			set M [measure center $sel]
			set R [expr $MaxSphereSize - $j]
			graphics top sphere $M radius $R resolution 250
		}
		
		mol modselect 0 top none

	}

	$sel delete

}

