#proc align {new old AlignRange} {
#proc align {

        #puts "Aligning molecule $new to molecule $old."
        #puts "The paramaters for the alignment are:"
        #puts $AlignRange

	for {set i 0} {$i<47} {incr i} {
        #set sel1 [atomselect $new $AlignRange]
        set sel1 [atomselect $i "type CA and residue 0 to 600"]
        #set sel1 [atomselect $i all]
        #set sel1 [mol $i type CA and residue 0 to 798]
        #set sel2 [atomselect $old $AlignRange]
        set sel2 [atomselect 47 "type CA and residue 0 to 600"]
        #set sel2 [atomselect 47 all]
        #set sel2 [mol 47 type CA and residue 0 to 798]
        set start_rmsd [measure rmsd $sel1 $sel2]
        #set move_sel [atomselect $new all]
        #set move_sel [atomselect $i all]
        set move_sel [atomselect $i "chain X or chain A"]
        set T_matrix [measure fit $sel1 $sel2]
        $move_sel move $T_matrix
        #set end_rmsd [measure rmsd $sel1 $sel2]

        puts "Alignment begun with RMSD: $start_rmsd"
        #puts "Alignment complete with RMSD: $end_rmsd"

        $sel1 delete
        $sel2 delete
        $move_sel delete

}
#}
