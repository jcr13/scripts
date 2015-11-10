#load all ftmap and sitemap data, then this adds reps of residues near sitemap surface
proc within-sitemap { number_of_files } {

#represent residues in licorice based on name
mol rep licorice
mol color name

#for holo-md-bound this eliminates active site residues and h3
mol selection same residue as (within 3 of resname SITE) and not residue 354 to 363 and not residue 370 to 391 and not residue 529 to 564 and not residue 799 to 814 and not residue 116 to 119 and not residue 138 to 140 and not residue 144 to 147 and not residue 160 and not residue 162 to 163 and not residue 165 and not residue 188 and not residue 190 and not residue 192 and not residue 205 to 206 and not residue 209 to 210 and not residue 212 to 213 and not residue 216 to 217 and not residue 220 to 221 and not residue 224 to 225 and not residue 365 to 366 and not residue 368 and not residue 368 to 369 and not residue 392 and not residue 394 and not residue 420 and not residue 454 to 455 and not residue 459 and not residue 465 to 467 and not residue 489 and not residue 507 and not residue 522 and not residue 525 and not residue 581 and not residue 586 and not residue 590 to 591 and not residue 631 to 632 and not residue 637 to 641 and not residue 644 and not residue 7

#add the representation
set i [expr $number_of_files + 1]
set j [expr $number_of_files * 2 + 1]
for {set k $i} {$k<$j} {incr k} {
	mol addrep $k
}

#save a pdb file for each with the residues
for {set l $i} {$l<$j} {incr l} {
	[atomselect $l "same residue as (within 3 of resname SITE) and not residue 354 to 363 and not residue 370 to 391 and not residue 529 to 564 and not residue 799 to 814 and not residue 116 to 119 and not residue 138 to 140 and not residue 144 to 147 and not residue 160 and not residue 162 to 163 and not residue 165 and not residue 188 and not residue 190 and not residue 192 and not residue 205 to 206 and not residue 209 to 210 and not residue 212 to 213 and not residue 216 to 217 and not residue 220 to 221 and not residue 224 to 225 and not residue 365 to 366 and not residue 368 and not residue 368 to 369 and not residue 392 and not residue 394 and not residue 420 and not residue 454 to 455 and not residue 459 and not residue 465 to 467 and not residue 489 and not residue 507 and not residue 522 and not residue 525 and not residue 581 and not residue 586 and not residue 590 to 591 and not residue 631 to 632 and not residue 637 to 641 and not residue 644 and not residue 7"] writepdb residues-within-3-of-sitemap-[expr $l - $number_of_files].pdb
}

}
