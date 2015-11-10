####################################################################################
	#This file contains all VMD scripts written by Nate Hurley in Summmer 2012
	#If you have any questions, I can be reached at natech@gmail.com
	#Additions by James C. Robertson and Victor H. Rusu, Spring 2013
	#
	#Reference DSV: Robertson JC, Hurley N, Tortorici M, Ciossani G, Borrello MT, Vellore NA, Ganesan A, Mattevi A, Baron R. Expanding the Druggable Space of the LSD1/CoREST Epigenetic Target: New Potential Binding Regions for Drug-Like Molecules, Peptides, Protein Partners, and Chromatin.  
	#
	#DSV Homepage, Download, and Tutorial  http://barongroup.medchem.utah.edu/tools
	#
	#After DSV.tcl has been downloaded it can be used with VMD in two ways:
	# 1) open VMD and use the 'source' command in the TKConsole to source the DSV.tcl, such as 'source ~/Downloads/DSV.tcl'
	# 2) insert DSV.tcl content into your .vmdrc, if you are comfortable editing the .vmdrc
###################################################################################
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

####################################################################################
	#
	#Aligns molecules and provides RMSD
	#
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

####################################################################################
	#
	#Sets some graphics options
	#
proc LoadGraphics {filename} {

	puts "Reading protein model from $filename."
	mol new $filename
	mol modselect 0 top protein
	
	#Edit the following lines to change the graphical representation of the protein model.
	mol modstyle 0 top QuickSurf
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

####################################################################################
	#
	#Visualize with 3 arguments: Visualize FTMap output
	#Example Usage: Visualize 1 5 ftmap-%d.pdb
	#  If you have 5 FTMap files named ftmap-1.pdb to ftmap-5.pdb this command will load all of them and use ftmap-1.pdb as reference structure to align them to. 
	#
overproc Visualize {start end fileformat} {
	#AlignRange is a key variable to edit for each system
	set AlignRange "type CA and residue 5 to 200"
	#These parameters can/should be edited when needed.
	#Note that currently, MaxSphereSize needs to be greater than or equal to SpheresToDisplay.
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

####################################################################################
	#
	#Visualize with 4 arguments
	#Example Usage: Visualize 1 5 ftmap-%d.pdb ref.pdb
        #  If you have 5 FTMap files named ftmap-1.pdb to ftmap-5.pdb this command will load all of them and use ref.pdb as reference structure to align them to
	#
overproc Visualize {start end fileformat template} {
	#AlignRange is a key variable to edit for each system
	set AlignRange "type CA and residue 5 to 200"
	#These parameters can/should be edited when needed.
	#Note that currently, MaxSphereSize needs to be greater than or equal to SpheresToDisplay.
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

####################################################################################
	#
	#Visualize with 5 arguments
	#Example Usage: Visualize 1 5 ftmap-%d.pdb 1 5 sitemap-%d.pdb
        #  If you have 5 FTMap files named ftmap-1.pdb to ftmap-5.pdb and 5 SiteMap files named sitemap-1.pdb to sitemap-5.pdb this command will load all of them and use ftmap-1.pdb as reference structure to align them to
	#
overproc Visualize {FTstart FTend FTfileformat STstart STend STfileformat} {
	#AlignRange is a key variable to edit for each system
	set AlignRange "type CA and residue 0 to 798"
	#These parameters can/should be edited when needed.
	#Note that currently, MaxSphereSize needs to be greater than or equal to SpheresToDisplay.
	#Change iValue to edit the isovalue for the isosurface of the volmap generated for Sitemap
	#results.  A smaller value will draw larger volumes, with a value of 0 giving an infinite size.
	#It is recommended that the iValue be set to around 0.3 to 0.5.
	set MaxSphereSize 10.0
	set SpheresToDisplay 10
	set SphereMaterial EdgyGlass
	set iValue 0.3

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
	
	#These loops load the Sitemap surfaces and colors them to match FTMap spheres
	for {set i $STstart} {$i <= $STend} {incr i} {
		set STfilename [format $STfileformat [expr $i]]
		puts "Reading file $STfilename"
		mol new $STfilename
		align [molinfo top] [molinfo index 0] $AlignRange
		}
	for {set l $FTend} {$l<[expr 2*$STend+1]} {incr l} {	
		set sel [atomselect $l "chain X"]
		volmap density $sel -res 0.3 -weight none -mol $l
		mol rep Isosurface $iValue 0 0 0 1 1
		mol material Opaque
		mol color Molecule
		}
	for {set k $FTend} {$k<[expr 2*$STend+1]} {incr k} {
		mol delrep 0 $k 
		mol addrep $k
		}
	color scale method RGB
	for {set m 0} {$m<$STend} {incr m} {
		set Num [expr 33 + {1023 * $m/[expr $STend-1]}]
		color Molecule [expr $m + $STend +1] $Num
	}
}

####################################################################################
	#
	#For loading SiteMap without loading FTMap
	#This colors surfaces according to the file rank
	#Example Usage: sitemap-color 1 5 sitemap-%d.pdb
	#  If you have 5 SiteMap files named sitemap-1.pdb to sitemap-5.pdb this will load all of them and align them to sitemap-1.pdb
	#
proc sitemap-color { STstart STend STfileformat } {
	#Change iValue to edit the isovalue for the isosurface of the volmap generated for Sitemap
	#results.  A smaller value will draw larger volumes, with a value of 0 giving an infinite size.
	#It is recommended that the iValue be set to around 0.3 to 0.5.
	set iValue 0.5

	set STfilename [format $STfileformat [expr $STstart]]
	puts "No initial template given.  Default template used."
	LoadGraphics $STfilename

	#AlignRange is a key variable to edit for each system
	set AlignRange "type CA and residue 5 to 200"

	for {set i $STstart} {$i <= $STend} {incr i} {
		set STfilename [format $STfileformat [expr $i]]
		puts "Reading file $STfilename"
		mol new $STfilename
		align [molinfo top] [molinfo index 0] $AlignRange
		}
	for {set l $STstart} {$l<=$STend} {incr l} {	
		set sel [atomselect $l "chain X"]
		volmap density $sel -res 0.3 -weight none -mol $l
		mol rep Isosurface $iValue 0 0 0 1 1
		mol material Opaque
		mol color Molecule
		}
	for {set k $STstart} {$k<=$STend} {incr k} {
		mol delrep 0 $k 
		mol addrep $k
		}
	color scale method RGB
	for {set m 0} {$m<$STend} {incr m} {
		set Num [expr 33 + {1023 * $m/$STend}]
		color Molecule [expr $m +1] $Num
	}
}

####################################################################################
	#
	#Select residues near FTMap CSs and SiteMap sites, display the residues
	#Three representations are created on the first molecule
	#	One:Residues near FTMap CSs
	#	Two:Residues near SiteMap sites
	#	Three:Residues near both FTMap and SiteMap
	#Hide or display representations to view the representation of interest
	#
proc select-residues { FTstart FTend FTfileformat STstart STend STfileformat } {
	#
	# Reading the FTMap Files
	#
	set oi [molinfo list]
	set lastTopBeforeFTMap [lrange $oi [expr [llength $oi] - 1]  [expr [llength $oi] - 1]]

	#AlignRange is a key variable to edit for each system
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
		#atomselection defines which residues will be displayed. Edit to change distance or other paramters.
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
	# Setting the represenation for residues near FTMap CSs
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

	#AlignRange is a key variable to edit for each system
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
		#atomselection defines which residues will be displayed. Edit to change distance or other paramters.
		set sel [atomselect $i "same residue as (within 3 of residuetype nothing) and chain A"]
        	foreach {j} [$sel get residue] {
			if { [lsearch $lSTMapResidues $j] == -1 } {
				lappend lSTMapResidues $j
			}
        	}
	}

 	#
	# Setting the representation of residues near SiteMap sites
	#
	set active [expr $lastTopBeforeFTMap + 0]
	mol top $active

	mol representation Licorice 0.3 10 10
        mol selection "residue $lSTMapResidues"
        mol color Name
        mol material Opaque
        mol addrep top

	#
	#Selecting residues present near both FTMap CSs and SiteMap sites
	#
        set lBothResidues []
        foreach {i} $lFTMapResidues  {
        	if { [lsearch $lSTMapResidues $i] != -1 } {
                	lappend lBothResidues $i
                }
        }

        #
        # Setting the representation of residues near both FTMap CSs and SiteMap sites
        #
        mol representation Licorice 0.3 10 10
        mol selection "residue $lBothResidues"
        mol color Name
        mol material Opaque
        mol addrep top
}

####################################################################################
	#This script parses a multiframe PDB file into some number of files, each consisting of a single frame.
	#To use this script, the PDB file of interest must already be loaded into VMD.
	#This script will only extract the value specified by ExtractTarget.
	#
	#This script will prompt the user for the first and last frames to be saved as individual files.
	#All files between these values will be saved.
	#
	#The script will prompt the user for an output name.
	#For instance, if the output files should be titled Sample0001.pdb, Sample0002.pdb, etc.,
	#the input should be:
	#	Sample%04d.pdb
	#
	#Example usage of the script:
	#	mol new clusters.pdb
	#	parse top
	#	0
	#	5
	#	Sample%d.pdb
	#
	#The script will save the first six frames of clusters.pdb to Sample0.pdb, Sample1.pdb, ... Sample5.pdb.
	#
	#The script currently defaults to extract the value of ExtractTarget (chain A).
	#However, adding an argument will change this value.
	#Example:
	#	parse top "chain A and chain B"

	#
	#parse with 1 argument
	#
overproc parse {molecule} {

	#Change this value to modify what part of the protein is extracted
	set ExtractTarget "chain A"
	
	puts "I see that molecule $molecule has [molinfo top get numframes] frames."
	puts "I will only be extracting atoms that are labeled as $ExtractTarget."
	puts -nonewline "What is the first frame to grab? "
	set beg [gets stdin]
	puts -nonewline "What is the last frame to grab? "
	set end [gets stdin]
	puts "What should the output files be named?"
	puts "Note: use %d as a variable for frame numbers."
	puts "To set a fixed number of digits n, use %0nd."
	puts -nonewline "Output file names? "
	set fileformat [gets stdin]

	for {set i $beg} {$i <= $end} {incr i} {
		puts "Beginning for loop iteration [expr $i - $beg]"
		set filename [format $fileformat [expr $i]]
		puts "Filename is $filename"
		set sel [atomselect top $ExtractTarget]
		animate write pdb $filename beg $i end $i skip 1 sel $sel $molecule
		puts "Ending for loop iteration [expr $i - $beg]"
	}
}

####################################################################################
	#
	#parse with 2 arguments
	#
overproc parse {molecule ExtractTarget} {
	
	puts "I see that molecule $molecule has [molinfo top get numframes] frames."
	puts "I will only be extracting atoms that are labeled as $ExtractTarget."
	puts -nonewline "What is the first frame to grab? "
	set beg [gets stdin]
	puts -nonewline "What is the last frame to grab? "
	set end [gets stdin]
	puts "What should the output files be named?"
	puts "Note: use %d as a variable for frame numbers."
	puts "To set a fixed number of digits n, use %0nd."
	puts -nonewline "Output file names? "
	set fileformat [gets stdin]

	for {set i $beg} {$i <= $end} {incr i} {
		puts "Beginning for loop iteration [expr $i - $beg]"
		set filename [format $fileformat [expr $i]]
		puts "Filename is $filename"
		set sel [atomselect top $ExtractTarget]
		animate write pdb $filename beg $i end $i skip 1 sel $sel $molecule
		puts "Ending for loop iteration [expr $i - $beg]"
	}
}

####################################################################################
	#This script extracts all protein molecules from a set of .pdb files, places
	#them inside "chain A," and then saves the protein.
	#
	#Example usage for input files File1.pdb, File2.pdb, File3.pdb
	#	source ChainA.tcl
	#	ChainA 1 3 File%d.pdb File%d-AllChainA.pdb
	#
	#Output will be saved to File1-AllChainA.pdb, File2-AllChainA.pdb,
	#and File3-AllChainA.pdb
	#Only the protein will be saved, and all of the protein will be labled
	#as "Chain A."

proc ChainA {start end name newname} {
	
	for {set i $start} {$i <= $end} {incr i} {
		set filename [format $name [expr $i]]
		puts "Loading $filename"
		mol new $filename
		
		set sel [atomselect top protein]
		$sel set chain A
		
		set filename [format $newname [expr $i]]
		puts "Saving $filename"
		animate write pdb $filename beg 0 end 0 skip 1 top
		puts "$filename saved."
		
		$sel delete
		mol delete top
	}

}
