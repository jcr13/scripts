#!/usr/bin/env python

from sys import argv

script, n_steps_completed = argv

# sampling time (ns) for between each replica exchange
# bigger_timestep
time_step = 4.5
# options.timesteps
steps_rep = 11111
# convert to ns
fs_to_ps = 0.001
ps_to_ns = 0.001
# from remd.log and input to this script as arg[1]
N_steps_completed = int(float(n_steps_completed))
# do the math
rep_time = time_step * steps_rep * fs_to_ps * ps_to_ns * N_steps_completed

# print time sampled (ns) to two decimals
print "rep_time %.2f" % rep_time
