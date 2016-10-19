proc draw_cyls { molnum atom1 atom2} {
    # e.g. atom1: "resid 18 and name CB"
    # set atom numbers
    set sel1 [atomselect $molnum "$atom1"]
    set sel2 [atomselect $molnum "$atom2"]
    # set the coords
    set coord1 [lindex [$sel1 get {x y z}] 0]
    set coord2 [lindex [$sel2 get {x y z}] 0]
    # draw the cylinder
    graphics $molnum cylinder $coord1 $coord2 radius 0.5 filled yes
    # to delete all cylinders (or instead of all sub in graphic id number)
    # graphics $molnum delete all
}
