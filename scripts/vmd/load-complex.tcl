#load complex
#e.g. load-complex complex-bsc0 1
#would be used if there was already a mol 0
proc load-complex {sys mol} {
    mol new traj/$sys/nowat.$sys.hmr.prmtop
    for {set i 1} {$i<4} {incr i} {mol addfile traj/$sys/$sys.$i.nc step 100}
    scale by 0.0001
    mol selection protein
    mol rep newcartoon
    mol addrep $mol
    mol selection nucleic
    mol rep licorice
    mol addrep $mol
    mol showrep $mol 0 off
    mol smoothrep $mol 1 3
    mol smoothrep $mol 2 3
}
