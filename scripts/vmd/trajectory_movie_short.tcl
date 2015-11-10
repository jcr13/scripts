proc make_trajectory_movie {sys freq} {
	# get the number of frames in the movie
	set num [molinfo top get numframes]
	# loop through the frames
	for {set i 0} {$i < $num} {incr i $freq} {
		# go to the given frame
		animate goto $i
                # for the display to update
                display update
		# take the picture
		set filename $sys-snap.[format "%04d" [expr $i/$freq]].rgb
		render snapshot $filename
	}
}
