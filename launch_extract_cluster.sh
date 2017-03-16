### Extract trajectories ###
cp /cavern/Casp12/Scripts/PostMeld/extract_trajectories_temp.sh .
PID=$(qsub extract_trajectories_temp.sh|awk '{print $3}'|cut -c 1-6)

### Cluster agglomerative ###
cp /cavern/Casp12/Scripts/PostMeld/hierarchical_clustering.sh .
qsub -hold_jid $PID  hierarchical_clustering.sh 

### Cluster density ###
cp /cavern/Casp12/Scripts/PostMeld/density_clustering.sh .
qsub -hold_jid $PID  density_clustering.sh 

