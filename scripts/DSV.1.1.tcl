	################################################################################
	#This file contains the DSV program developed in the lab of Riccardo Baron     #
	#University of Utah College of Pharmacy, Department of Medicinal Chemistry     #
	#barongroup.medchem.utah.edu                                                   #
	#Citation: Robertson JC, Hurley N, Tortorici M, Ciossani G, Borrello MT, Vellore NA, Ganesan A, Mattevi A, Baron R. Expanding the Druggable Space of LSD1/CoREST Epigenetic Target: New Potential Binding Regions for Drug-Like Molecules, Peptides, Protein Partners, and Chromatin. 2013, PLOS Comp Biol, 9(7):e1003158. doi:10.1371/journal.pcbi.1003158
	#                                                                              #
	#Scripts originally written by Nate Hurley (natech@gmail.com) in Summmer 2012  #
	#Additions and modifications by James C. Robertson and Victor H. Rusu, 2013    #
	#Version 1.1 Nov 11 2013
	################################################################################

	############################
	# overproc from tcl wiki:  #
	# http://www2.tcl.tk/20409 #
####################################
proc overproc {n p b} {
      # define dispatcher
      uplevel [list proc $n {args} [string map [list %N $n] {
          uplevel [list "%N with [llength $args] args"] $args
      }]]
      # define the function itself
      uplevel [list proc "$n with [llength $p] args" $p $b]
}

	################################################################################
	# Aligns molecules and provides RMSD. Use VMD atomselect syntax for $AlignRange #
	# Example: align 0 1 "type CA and residue 5 to 200"                             #
	# Where 0 and 1 are mol numbers and mol 1 is the reference mol                  #
########################################################################################
proc align {query ref AlignRange} {

	puts "Aligning molecule $query to molecule $ref."
	puts "The paramaters for the alignment are: $AlignRange"

	set sel1 [atomselect $query $AlignRange]
	set sel2 [atomselect $ref $AlignRange]
	set start_rmsd [measure rmsd $sel1 $sel2]
	set move_sel [atomselect $query all]
	set T_matrix [measure fit $sel1 $sel2]
	$move_sel move $T_matrix
	set end_rmsd [measure rmsd $sel1 $sel2]

	puts "Alignment begun with RMSD: $start_rmsd"
	puts "Alignment complete with RMSD: $end_rmsd"
	
	$sel1 delete
	$sel2 delete
	$move_sel delete
}

	##############################
	# Sets some graphics options #
######################################
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

	###########################################################################################################
	# Visualize FTMap results from an ensemble of structures on first protein loaded                          #
	# Example: VisFT 1 3 ftmap-%d.pdb                                                                         #
	# Where ftmap-1.pdb, ftmap-2.pdb and ftmap-3.pdb will be aligned to ftmap-1.pdb #
###################################################################################################################
overproc VisFT {FTstart FTend FTfileformat} {
	#AlignRange is a key variable to edit for each system
	set AlignRange "type CA and residue 5 to 200"
	#These parameters can/should be edited when needed.
	#Note that currently, MaxSphereSize needs to be greater than or equal to SpheresToDisplay.
	set MaxSphereSize 5.0
	set SpheresToDisplay 5
	set SphereMaterial EdgyGlass
	
	set filename [format $FTfileformat [expr $FTstart]]
	puts "No initial template given.  The 'FTstart' molecule will be used as template."
	LoadGraphics $filename
        set TemplateNum [molinfo top]

	set NumFiles [expr {($FTend - $FTstart)? ($FTend - $FTstart):1 }]
	set CurFile 0
	
	#This loop draws spheres affiliated with FTClusters.
	for {set i $FTstart} {$i <= $FTend} {incr i} {
		set filename [format $FTfileformat [expr $i]]
		puts "Reading file $filename"
		mol new $filename
		#align [molinfo top] [molinfo index 0] $AlignRange
		align [molinfo top] $TemplateNum $AlignRange

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
		ftmap-1.pdb, ftmap-2.pdb, ftamp-3.pdb, ftamp-4.pdb, and ftmap-5.pdb	graphics top sphere $M radius $R resolution 250
		}
		mol modselect 0 top none
	}
	$sel delete
}

	#########################################################################################################
	# Visualize FTMap results from an ensemble of structures on a specified reference structure             #
	# Example: VisFTMap 1 3 ftmap-%d.pdb 2V1D.pdb                                                           #
	# Where ftmap-1.pdb, ftmap-2.pdb and ftamp-3.pdb will be aligned to 2V1D.pdb #
#################################################################################################################
overproc VisFTRef {FTstart FTend FTfileformat template} {
	#AlignRange is a key variable to edit for each system
	set AlignRange "type CA and residue 5 to 200"
	#These parameters can/should be edited when needed.
	#Note that currently, MaxSphereSize needs to be greater than or equal to SpheresToDisplay.
	set MaxSphereSize 5.0
	set SpheresToDisplay 5
	set SphereMaterial EdgyGlass
	
	set filename [format $FTfileformat [expr $FTstart]]
	puts "$template will be used as template."
	LoadGraphics $template
	set TemplateNum [molinfo top]

	set NumFiles [expr {($FTend - $FTstart)? ($FTend - $FTstart):1 }]
	set CurFile 0
	
	#This loop draws spheres affiliated with FTClusters.
	for {set i $FTstart} {$i <= $FTend} {incr i} {
		set filename [format $FTfileformat [expr $i]]
		puts "Reading file $filename"
		mol new $filename
		align [molinfo top] $TemplateNum $AlignRange

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

        ########################################################################################################################
        # Visualize SiteMap results from an ensemble of structures on first protein loaded                                     #
	# Example: VisST 1 3 sitemap-%d.pdb                                                                                    #
	# Where sitemap-1.pdb, sitemap-2.pdb and sitemap-3.pdb will be aligned to sitemap-1.pdb #
################################################################################################################################
    overproc VisST { STstart STend STfileformat } {
        #Change iValue to edit the isovalue for the isosurface of the volmap generated for Sitemap
        #surfaces. A smaller value will draw larger volumes, with a value of 0 giving an infinite size.
        #Recommended iValue is about 0.3 to 0.5.
        set iValue 0.3
        #AlignRange is a key variable to edit for each system
        set AlignRange "type CA and residue 5 to 200"
    
        set STfilename [format $STfileformat [expr $STstart]]
        puts "No initial template given. The 'STstart' molecule will be used as template."
        LoadGraphics $STfilename
        set TemplateNum [molinfo top]
        
        set NumFiles [expr {($STstart - $STend)? ($STend - $STstart):1}]
        set STCurFile 0
    
        #This loop loads and aligns the structures
        for {set i $STstart} {$i <= $STend} {incr i} {
    	set STfilename [format $STfileformat [expr $i]]
    	puts "Reading file $STfilename"
    	mol new $STfilename
    	align [molinfo top] $TemplateNum $AlignRange
    	}
    	
        #This loop adds the surface represenation that correlates with SiteMap sites
        set lasttop [expr [molinfo top]]
        for {set l [expr $lasttop - $NumFiles ]} {$l <= $lasttop} {incr l} {
    	set sel [atomselect $l "chain X"]
    	volmap density $sel -res 0.3 -weight none -mol $l
    	mol rep Isosurface $iValue 0 0 0 1 1
    	mol material Opaque
    	mol color Molecule
            mol delrep 0 $l
            mol addrep $l
    	set Num [expr 33 + {1023 * $STCurFile/$NumFiles}]
    	incr STCurFile
    	color Molecule $l $Num
           }
    }

        ############################################################################################################
        # Visualize SiteMap results from an ensemble of structures on a specified reference structure              #
        # Example: VisSiteMap 1 3 sitemap-%d.pdb 2V1D.pdb                                                          #
        # Where sitemap-1.pdb, sitemap-2.pdb and sitemap-3.pdb are aligned to 2V1D.pdb  #
####################################################################################################################
    overproc VisSTRef { STstart STend STfileformat template } {
        #Change iValue to edit the isovalue for the isosurface of the volmap generated for Sitemap
        #surfaces.  A smaller value will draw larger volumes, with a value of 0 giving an infinite size.
        #Recommended iValue is about 0.3 to 0.5.
        set iValue 0.3
        #AlignRange is a key variable to edit for each system
        set AlignRange "type CA and residue 5 to 200"
     
        set STfilename [format $STfileformat [expr $STstart]]
        puts "$template will be used as template."
        LoadGraphics $template
        set TemplateNum [molinfo top]
       
        set NumFiles [expr {($STstart - $STend)? ($STend - $STstart):1}]
        set STCurFile 0
     
        #This loop loads and aligns the structures
        for {set i $STstart} {$i <= $STend} {incr i} {
            set STfilename [format $STfileformat [expr $i]]
            puts "Reading file $STfilename"
            mol new $STfilename
    	align [molinfo top] $TemplateNum $AlignRange
            }
     
        #This loop adds the surface represenation that correlates with SiteMap sites
        set lasttop [expr [molinfo top]]
        for {set l [expr $lasttop - $NumFiles ]} {$l <= $lasttop} {incr l} {
            set sel [atomselect $l "chain X"]
            volmap density $sel -res 0.3 -weight none -mol $l
            mol rep Isosurface $iValue 0 0 0 1 1
            mol material Opaque
            mol color Molecule
            mol delrep 0 $l
            mol addrep $l
            set Num [expr 33 + {1023 * $STCurFile/$NumFiles}]
            incr STCurFile
            color Molecule $l $Num
           }
    }

	############################################################################################################################
	# Visualize both FTMap and SiteMap output from an ensemble of structures on first protein loaded                           #
	# Example: Visualize 1 3 ftmap-%d.pdb 1 3 sitemap-%d.pdb                                                                   #
	# Where ftmap-1.pdb, ftmap-2.pdb, ftamp-3.pdb, sitemap-1.pdb, sitemap-2.pdb, and sitemap-3.pdb will aligned to ftmap-1.pdb #
####################################################################################################################################
overproc Visualize {FTstart FTend FTfileformat STstart STend STfileformat} {
	#AlignRange is a key variable to edit for each system
	set AlignRange "type CA and residue 5 to 200"
	#These parameters can/should be edited when needed.
	#Note that currently, MaxSphereSize needs to be greater than or equal to SpheresToDisplay.
	#Change iValue to edit the isovalue for the isosurface of the volmap generated for Sitemap
	#surfaces.  A smaller value will draw larger volumes, with a value of 0 giving an infinite size.
	#Recommended iValue is about 0.3 to 0.5.
	set MaxSphereSize 5.0
	set SpheresToDisplay 5 
	set SphereMaterial EdgyGlass
	set iValue 0.3

	set FTfilename [format $FTfileformat [expr $FTstart]]
	puts "No initial template given.  Default template used."
	LoadGraphics $FTfilename
	set TemplateNum [molinfo top]
	
	#This is used for determining sphere colors.  Essentially, dividing the color scale would
	#require dividing by 0 if there was only one FTCluster.  This line keeps that from breaking.
	set FTNumFiles [expr {($FTend - $FTstart)? ($FTend - $FTstart):1 }]
	set FTCurFile 0
	
	#This for loop loads the FTClusters
	for {set i $FTstart} {$i <= $FTend} {incr i} {
		set FTfilename [format $FTfileformat [expr $i]]
		puts "Reading file $FTfilename"
		mol new $FTfilename
		align [molinfo top] $TemplateNum $AlignRange
		
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
		align [molinfo top] $TemplateNum $AlignRange
		}
	set lasttop [expr [molinfo top]]
	set STCurFile 0
	set NumSTFiles [expr {($STstart - $STend)? ($STend - $STstart):1} + 1]
	for {set l [expr $lasttop - $FTNumFiles]} {$l <= $lasttop} {incr l} {	
		set sel [atomselect $l "chain X"]
		volmap density $sel -res 0.3 -weight none -mol $l
		mol rep Isosurface $iValue 0 0 0 1 1
		mol material Opaque
		mol color Molecule
		mol delrep 0 $l 
		mol addrep $l
		set Num [expr 33 + {1023 * $STCurFile/$NumSTFiles}]
		incr STCurFile
		color Molecule $l $Num
		}
}

        #########################################################################################################################
        # Visualize both FTMap and SiteMap output from an ensemble of structures on a specified reference structure             #
	# Example: VisualizeRef 1 3 ftmap-%d.pdb 1 3 sitemap-%d.pdb 2V1D.pdb                                                    #
	# Where ftmap-1.pdb, ftmap-2.pdb, ftamp-3.pdb, sitemap-1.pdb, sitemap-2.pdb, and sitemap-3.pdb will aligned to 2V1D.pdb #
#################################################################################################################################
    overproc VisualizeRef {FTstart FTend FTfileformat STstart STend STfileformat template} {
        #AlignRange is a key variable to edit for each system
        set AlignRange "type CA and residue 5 to 200"
        #These parameters can/should be edited when needed.
        #Note that currently, MaxSphereSize needs to be greater than or equal to SpheresToDisplay.
        #Change iValue to edit the isovalue for the isosurface of the volmap generated for Sitemap
        #surfaces.  A smaller value will draw larger volumes, with a value of 0 giving an infinite size.
        #Recommended iValue is about 0.3 to 0.5.
        set MaxSphereSize 5.0
        set SpheresToDisplay 5 
        set SphereMaterial EdgyGlass
        set iValue 0.3
    
        set FTfilename [format $FTfileformat [expr $FTstart]]
        puts "$template will be used as template."
        LoadGraphics $template
        set TemplateNum [molinfo top]
        
        #This is used for determining sphere colors.  Essentially, dividing the color scale would
        #require dividing by 0 if there was only one FTCluster.  This line keeps that from breaking.
        set FTNumFiles [expr {($FTend - $FTstart)? ($FTend - $FTstart):1 }]
        set FTCurFile 0
        
        #This for loop loads the FTClusters
	for {set i $FTstart} {$i <= $FTend} {incr i} {
	   set FTfilename [format $FTfileformat [expr $i]]
	   puts "Reading file $FTfilename"
	   mol new $FTfilename
	   align [molinfo top] $TemplateNum $AlignRange
    	
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
    	   align [molinfo top] $TemplateNum $AlignRange
    	   }
        set lasttop [expr [molinfo top]]
        set STCurFile 0
        set NumSTFiles [expr {($STstart - $STend)? ($STend - $STstart):1} + 1]
        for {set l [expr $lasttop - $FTNumFiles]} {$l <= $lasttop} {incr l} {   
	   set sel [atomselect $l "chain X"]
    	   volmap density $sel -res 0.3 -weight none -mol $l
    	   mol rep Isosurface $iValue 0 0 0 1 1
    	   mol material Opaque
    	   mol color Molecule
    	   mol delrep 0 $l 
    	   mol addrep $l
    	   set Num [expr 33 + {1023 * $STCurFile/$NumSTFiles}]
    	   incr STCurFile
    	   color Molecule $l $Num
    	   }
    }

        #################################################################################################################
        # Select residues from an ensemble of structures near FTMap CSs and display the residues on the first structure #
	# Example: SelResFT 1 3 ftmap-%d.pdb                                                                            #
	# Where residues near FTMap CSs on ftmap-1.pdb, ftmap-2.pdb, and ftmap-3.pdb will be displayed on ftmap-1.pdb   #
#########################################################################################################################
    proc SelResFT { FTstart FTend FTfileformat } {
        #AlignRange is a key variable to edit for each system
        set AlignRange "type CA and residue 5 to 200"
    
        set filename [format $FTfileformat [expr $FTstart]]
        puts "No initial template given. The 'FTstart' molecule will be used as template."
        LoadGraphics $filename
        set TemplateNum [molinfo top]
    
        for {set k $FTstart} {$k <= $FTend} {incr k} {
	   set filename [format $FTfileformat [expr $k]]
    	   puts "Reading file $filename"
    	   mol new $filename
    	   align [molinfo top] $TemplateNum $AlignRange
    	}
    
        set lFTMapResidues []
        set NumFTMapfiles [expr {($FTend - $FTstart)? ($FTend - $FTstart):1 }]
        set FTCurFile 0
        set lasttop [expr [molinfo top]]
        for {set i [expr $lasttop - $NumFTMapfiles]} {$i <= $lasttop} {incr i} {
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
    
        # Setting the Protein to NewCartoon and Transparent
        set active $TemplateNum
        mol top $active
            mol on $active
            mol representation NewCartoon 0.3 10 4.5
    	mol selection "all"
            mol material Opaque
            mol addrep top
    
        # Setting the represenation for residues near FTMap CSs
        mol representation Licorice 0.3 10 10
            mol selection "residue $lFTMapResidues"
            mol color Name
            mol material Opaque
            mol addrep top
    }

        #############################################################################################################################
        # Select residues from an ensemble of structures near FTMap CSs and display the residues on a specified reference structure #
	# Example:SelResFTRef 1 3 ftmap-%d.pdb 2V1D.pdb                                                                             #
	# Where residues near FTMap CSs on ftmap-1.pdb, ftmap-2.pdb, and ftmap-3.pdb will be displayed on 2V1D.pdb                  #
#####################################################################################################################################
    proc SelResFTRef { FTstart FTend FTfileformat template} {
        #AlignRange is a key variable to edit for each system
        set AlignRange "type CA and residue 5 to 200"
    
        set filename [format $FTfileformat [expr $FTstart]]
        puts "$template will be used as template."
        LoadGraphics $template
        set TemplateNum [molinfo top]
    
        for {set k $FTstart} {$k <= $FTend} {incr k} {
	    set filename [format $FTfileformat [expr $k]]
            puts "Reading file $filename"
            mol new $filename
            align [molinfo top] $TemplateNum $AlignRange
        }
    
        set lFTMapResidues []
        set NumFTMapfiles [expr {($FTend - $FTstart)? ($FTend - $FTstart):1 }]
        set FTCurFile 0
        set lasttop [expr [molinfo top]]
        for {set i [expr $lasttop - $NumFTMapfiles]} {$i <= $lasttop} {incr i} {
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
    
        # Setting the Protein to NewCartoon and Transparent
        set active $TemplateNum
        mol top $active
        mol on $active
        mol representation NewCartoon 0.3 10 4.5
        mol selection "all"
        mol material Opaque
        mol addrep top
    
        # Setting the represenation for residues near FTMap CSs
        mol representation Licorice 0.3 10 10
        mol selection "residue $lFTMapResidues"
        mol color Name
        mol material Opaque
        mol addrep top
    }

        ###########################################################################################################################
        # Select residues from and ensemble of structures near SiteMap sites and display the residues on the first structure      #
	# Example: SelResST 1 3 sitemap-%d.pdb                                                                                    #
	# Where residues near SiteMap sites on sitemap-1.pdb, sitemap-2.pdb, and sitemap-3.pdb will be displayed on sitemap-1.pdb #
###################################################################################################################################
    proc SelResST { STstart STend STfileformat } {
        #AlignRange is a key variable to edit for each system
        set AlignRange "type CA and residue 5 to 200"
    
        set STfilename [format $STfileformat [expr $STstart]]
        puts "No initial template given. The 'STstart' molecule will be used as template."
        LoadGraphics $STfilename
        set TemplateNum [molinfo top]
    
        #This loop loads and aligns the structures
	    for {set i $STstart} {$i <= $STend} {incr i} {
    	    set STfilename [format $STfileformat [expr $i]]
    	    puts "Reading file $STfilename"
    	    mol new $STfilename
    	    align [molinfo top] $TemplateNum $AlignRange
        }
    
        set lSTMapResidues []
        set NumSTMapfiles [expr {($STend - $STstart)? ($STend - $STstart):1 }]
        set STCurFile 0
        set lasttop [expr [molinfo top]]
        for {set j [expr $lasttop - $NumSTMapfiles]} {$j <= $lasttop} {incr j} {
    	mol top $j
    	mol off $j
        #atomselection defines which residues will be displayed. Edit to change distance or other parameters.
        set sel [atomselect $j "same residue as (within 3 of residuetype nothing) and chain A"]
        foreach {k} [$sel get residue] {
    	if { [lsearch $lSTMapResidues $k] == -1 } {
    	    lappend lSTMapResidues $k
    	    }
    	}
        }
    
        #Settting the protein to NewCartoon
        set active $TemplateNum
        mol top $active
        mol on $active
        mol representation NewCartoon 0.3 10 4.5
        mol selection "all"
        mol material Opaque
        mol addrep top
    
        #Setting the representation of residues near SiteMap sites
        mol representation Licorice 0.3 10 10
        mol selection "residue $lSTMapResidues"
        mol color Name
        mol material Opaque
        mol addrep top
    }

        ##################################################################################################################################
        # Select residues from and ensemble of structures near SiteMap sites and display the residues on a specified reference structure #
	# Example: SelResSTRef 1 3 sitemap-%d.pdb 2V1D.pdb                                                                               #
	# Where residues near SiteMap sites on sitemap-1.pdb, sitemap-2.pdb, and sitemap-3.pdb will be displayed on 2V1D.pdb             #
##########################################################################################################################################
    proc SelResSTRef { STstart STend STfileformat template } {
        #AlignRange is a key variable to edit for each system
        set AlignRange "type CA and residue 5 to 200"
    
        set STfilename [format $STfileformat [expr $STstart]]
        puts "No initial template given. The 'STstart' molecule will be used as template."
        LoadGraphics $template
        set TemplateNum [molinfo top]
    
        #This loop loads and aligns the structures
        for {set i $STstart} {$i <= $STend} {incr i} {
	   set STfilename [format $STfileformat [expr $i]]
    	   puts "Reading file $STfilename"
    	   mol new $STfilename
    	   align [molinfo top] $TemplateNum $AlignRange
        }
    
        set lSTMapResidues []
        set NumSTMapfiles [expr {($STend - $STstart)? ($STend - $STstart):1 }]
        set STCurFile 0
        set lasttop [expr [molinfo top]]
        for {set j [expr $lasttop - $NumSTMapfiles]} {$j <= $lasttop} {incr j} {
    	mol top $j
    	mol off $j
        #atomselection defines which residues will be displayed. Edit to change distance or other parameters.
        set sel [atomselect $j "same residue as (within 3 of residuetype nothing) and chain A"]
    	foreach {k} [$sel get residue] {
    	    if { [lsearch $lSTMapResidues $k] == -1 } {
    		lappend lSTMapResidues $k
    	    }
    	}
        }
    
        #Settting the protein to NewCartoon
        set active $TemplateNum
        mol top $active
        mol on $active
        mol representation NewCartoon 0.3 10 4.5
        mol selection "all"
        mol material Opaque
        mol addrep top
    
        #Setting the representation of residues near SiteMap sites
        mol representation Licorice 0.3 10 10
        mol selection "residue $lSTMapResidues"
        mol color Name
        mol material Opaque
        mol addrep top
    }

        #############################################################################################################
        # Select residues from an ensemble of structures and display residues that are near both FTMap and SiteMap (not one or the other, so if a residue is near a SiteMap site but not a FTMap site it will not be displayed). The residues are displayed on the first protein loaded. #
	# Example: SelResFTST 1 3 ftmap-%d.pdb 1 3 sitemap-%d.pdb
	# Where residues near FTMap CSs and SiteMap sites near ftmap-1.pdb, ftmap-2.pdb, ftmap-3.pdb, sitemap-1.pdb, sitemap-2.pdb, and sitemap-3.pdb will be displayed on ftmap-1.pdb #
#####################################################################################################################
    proc SelResFTST {FTstart FTend FTfileformat STstart STend STfileformat} {
        #AlignRange is a key variable to edit for each system
        set AlignRange "type CA and residue 5 to 200"
        
        set filename [format $FTfileformat [expr $FTstart]]
        puts "No initial template given. The 'FTstart' molecule will be used as template."
        LoadGraphics $filename
        set TemplateNum [molinfo top]
        
        for {set k $FTstart} {$k <= $FTend} {incr k} {
	   set filename [format $FTfileformat [expr $k]]
    	   puts "Reading file $filename"
    	   mol new $filename
    	   align [molinfo top] $TemplateNum $AlignRange
    	}
    
        set lFTMapResidues []
        set NumFTMapfiles [expr {($FTend - $FTstart)? ($FTend - $FTstart):1 }]
        set FTCurFile 0
        set lasttop [expr [molinfo top]]
            for {set i [expr $lasttop - $NumFTMapfiles]} {$i <= $lasttop} {incr i} {
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
        #This loop loads and aligns the structures
        for {set i $STstart} {$i <= $STend} {incr i} {
	   set STfilename [format $STfileformat [expr $i]]
    	   puts "Reading file $STfilename"
    	   mol new $STfilename
    	   align [molinfo top] $TemplateNum $AlignRange
        }
        set lSTMapResidues []
        set NumSTMapfiles [expr {($STend - $STstart)? ($STend - $STstart):1 }]
        set STCurFile 0
        set lasttop [expr [molinfo top]]
    	for {set j [expr $lasttop - $NumSTMapfiles]} {$j <= $lasttop} {incr j} {
    	mol top $j
    	mol off $j
    	#atomselection defines which residues will be displayed. Edit to change distance or other parameters.
    	set sel [atomselect $j "same residue as (within 3 of residuetype nothing) and chain A"]
    	    foreach {k} [$sel get residue] {
    	    if { [lsearch $lSTMapResidues $k] == -1 } {
    	    lappend lSTMapResidues $k
    	    }
    	}
        }
        #Settting the protein to NewCartoon
        set active $TemplateNum
        mol top $active
        mol on $active
        mol representation NewCartoon 0.3 10 4.5
        mol selection "all"
        mol material Opaque
        mol addrep top
        #Selecting residues present near both FTMap CSs and SiteMap sites
        set lBothResidues []
            foreach {i} $lFTMapResidues  {
    	    if { [lsearch $lSTMapResidues $i] != -1 } {
    	    lappend lBothResidues $i
                }
            }
        # Setting the representation of residues near both FTMap CSs and SiteMap sites
        mol representation Licorice 0.3 10 10
        mol selection "residue $lBothResidues"
        mol color Name
        mol material Opaque
        mol addrep top
    }

        #############################################################################################################
        # Select residues from an ensemble of structures and display residues that are near both FTMap and SiteMap (not one or the other, so if a residue is near a SiteMap site but not a FTMap site it will not be displayed). The residues are displayed on a specified reference structure . #
	# Example: SelResFTSTRef 1 3 ftmap-%d.pdb 1 3 sitemap-%d.pdb 2V1D.pdb
        # Where residues near FTMap CSs and SiteMap sites near ftmap-1.pdb, ftmap-2.pdb, ftmap-3.pdb, sitemap-1.pdb, sitemap-2.pdb, and sitemap-3.pdb will be displayed on 2V1D.pdb #
#####################################################################################################################
    proc SelResFTSTRef {FTstart FTend FTfileformat STstart STend STfileformat template} {
        #AlignRange is a key variable to edit for each system
        set AlignRange "type CA and residue 5 to 200"
        
        set filename [format $FTfileformat [expr $FTstart]]
        puts "No initial template given. The 'FTstart' molecule will be used as template."
        LoadGraphics $template
        set TemplateNum [molinfo top]
        
        for {set k $FTstart} {$k <= $FTend} {incr k} {
	    set filename [format $FTfileformat [expr $k]]
            puts "Reading file $filename"
            mol new $filename
            align [molinfo top] $TemplateNum $AlignRange
        }
    
        set lFTMapResidues []
        set NumFTMapfiles [expr {($FTend - $FTstart)? ($FTend - $FTstart):1 }]
        set FTCurFile 0
        set lasttop [expr [molinfo top]]
            for {set i [expr $lasttop - $NumFTMapfiles]} {$i <= $lasttop} {incr i} {
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
        #This loop loads and aligns the structures
        for {set i $STstart} {$i <= $STend} {incr i} {
	    set STfilename [format $STfileformat [expr $i]]
            puts "Reading file $STfilename"
            mol new $STfilename
            align [molinfo top] $TemplateNum $AlignRange
        }
        set lSTMapResidues []
        set NumSTMapfiles [expr {($STend - $STstart)? ($STend - $STstart):1 }]
        set STCurFile 0
        set lasttop [expr [molinfo top]]
        for {set j [expr $lasttop - $NumSTMapfiles]} {$j <= $lasttop} {incr j} {
        mol top $j
        mol off $j
        #atomselection defines which residues will be displayed. Edit to change distance or other parameters.
        set sel [atomselect $j "same residue as (within 3 of residuetype nothing) and chain A"]
            foreach {k} [$sel get residue] {
            if { [lsearch $lSTMapResidues $k] == -1 } {
            lappend lSTMapResidues $k
            }
        }
        }
        #Settting the protein to NewCartoon
        set active $TemplateNum
        mol top $active
        mol on $active
        mol representation NewCartoon 0.3 10 4.5
        mol selection "all"
        mol material Opaque
        mol addrep top
        #Selecting residues present near both FTMap CSs and SiteMap sites
        set lBothResidues []
            foreach {i} $lFTMapResidues  {
            if { [lsearch $lSTMapResidues $i] != -1 } {
            lappend lBothResidues $i
                }
            }
        # Setting the representation of residues near both FTMap CSs and SiteMap sites
        mol representation Licorice 0.3 10 10
        mol selection "residue $lBothResidues"
        mol color Name
        mol material Opaque
        mol addrep top
    }

	##########################################################################################################
	# This script parses a multiframe PDB file into some number of files, each consisting of a single frame. #
	# To use this script, the PDB file of interest must already be loaded into VMD.                          #
	# This script will prompt the user for the first and last frames to be saved as individual files.        #
	# All files between these values will be saved.							       	 #
	# The script will prompt the user for an output name.                                                    #
	# For instance, if the output files should be titled Sample0001.pdb, Sample0002.pdb, etc.,               #
	# the input should be:                                                                                   #
	#	Sample%04d.pdb                                                                                   #
	# Example usage of the script:                                                                           #
	#	mol new clusters.pdb                                                                             #
	#	parse top                                                                                        #
	#	0                                                                                                #
	#	5                                                                                                #
	#	Sample%d.pdb                                                                                     #
	# The script will save the first six frames of clusters.pdb to Sample0.pdb, Sample1.pdb,...Sample5.pdb.  #
##################################################################################################################
overproc parse {molecule} {
	#Edit this value to modify what part of the protein is extracted
	set ExtractTarget "chain A"
	
	puts "Molecule $molecule has [molinfo top get numframes] frames."
	puts "$ExtractTarget from $molecule will be extracted."
	puts -nonewline "What is the first frame to grab?"
	set beg [gets stdin]
	puts -nonewline "What is the last frame to grab?"
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

	##########################################################################################################
	# This script parses a multiframe PDB file into some number of files, each consisting of a single frame. #
	# The use of this script is the same as above except that 'ExtractTarget' is declared as an argument.    #
##################################################################################################################
overproc parse {molecule ExtractTarget} {
	#Edit this value to modify what part of the protein is extracted	

	puts "Molecule $molecule has [molinfo top get numframes] frames."
	puts "$ExtractTarget from $molecule will be extracted."
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

	#############################################################################################
	# This script extracts a selection from a set of .pdb files                                 #
	# The extracted selection can then be saved in a new set of files as "chain A".             #
	# The selection and the "chain A" value can be edited for custom use.                       #
	# Example usage for input files File1.pdb, File2.pdb, File3.pdb                             #
	#	ChainA 1 3 File%d.pdb File%d-AllChainA.pdb                                          #
	# Output will be saved to File1-AllChainA.pdb, File2-AllChainA.pdb, and File3-AllChainA.pdb #
	# Only the protein will be saved, and all of the protein will be labled "chain A."          #
#####################################################################################################
proc ChainA {start end name newname} {
	for {set i $start} {$i <= $end} {incr i} {
		set filename [format $name [expr $i]]
		puts "Loading $filename"
		mol new $filename
	        #The atomselect value can be edited	
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
