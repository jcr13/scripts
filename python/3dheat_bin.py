#!/usr/bin/env python

from numpy import *

data_file = 'data.txt'
histogram_file = 'histogram.dat'

# data.txt should contain three col data
# of this format : serial_num value1 value2
# Here, angles are defined from [100 to 130[ degrees.
# You could choose another domain distance. Points will be automatically
# wrapped inside that domain. This can be useful for symetrical
# side chains, for instance. Be careful to use an appropriate domain,
# otherwise the wrapping will produce meaningless data.
x_min, x_max, y_min, y_max = -90, 90.0, -90.0, 90.0

# Number of 2D regions in which the plot is divided.
x_resolution, y_resolution = 100, 100

def read_angles(line):
    tokens = line.split()
    x = float(tokens[1])
    y = float(tokens[2])
    while x < x_min:
        x = x_max - (x_min - x)
    while x >= x_max:
        x = x_min + (x - x_max)
    while y < y_min:
        y = y_max - (y_min - y)
    while y >= y_max:
        y = y_min + (y - y_max)
    return [x, y]

points = [read_angles(line) for line in open(data_file)]
count = len(points)
histogram = zeros([x_resolution, y_resolution])
x_interval_length = (x_max - x_min) / x_resolution
y_interval_length = (y_max - y_min) / y_resolution
interval_surface = x_interval_length * y_interval_length
increment = 1000.0 / count / interval_surface

for i in points:
    x = int((i[0] - x_min) / x_interval_length)
    y = int((i[1] - y_min) / y_interval_length)
    histogram[x,y] += increment

x_intervals = arange(x_min, x_max, (x_max - x_min) / x_resolution)
y_intervals = arange(y_min, y_max, (y_max - y_min) / y_resolution)

o = open(histogram_file, 'w')
for i, x in enumerate(x_intervals):
    for j, y in enumerate(y_intervals):
        o.write('%f %f %f \n' % (x, y, histogram[i,j]/count))
    o.write('\n')
print histogram.max()
print count 
