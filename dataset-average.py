#!/usr/bin/python
# -*- coding: ISO-8859-1 -*-
#---------------------------------------------------------------------------#
# Function: Calculate the average value(s) of an xmgrace plot.              #
# Usage: average-xvg.py [options] <xvg-file> {<xvg-file> ... }              #
# Help: run average-xvg.py --help                                           #
# Author: Martti Louhivuori (m.j.louhivuori@rug.nl)                         #
# Version: 0.9 (23.02.2009)                                                 #
#---------------------------------------------------------------------------#
from optparse import OptionParser
import logging, sys
from Mara.IO import XVGIO
from numpy import array, sqrt

if __name__ == '__main__':
    usage = 'usage: %prog [options] <xvg-file> {<xvg-file> ... }'
    desc = 'Calculate the average value(s) of an xmgrace plot.'
    parser = OptionParser(usage=usage, description=desc)
    parser.add_option('-b', '--begin', 
            type='float', metavar='TIME', default=None, 
            help='begin from this TIME')
    parser.add_option('-e', '--end', 
            type='float', metavar='TIME', default=None, 
            help='end at this TIME')
    parser.add_option('-d', '--deviation', action='store_true', default=False, 
            help='estimate error using std.dev. instead of std.err.')
    parser.add_option('-s', '--separate', action='store_true', default=False, 
            help='calculate stats for positive and negative values separately')
    parser.add_option('-w', '--weight', action='store_true', default=False, 
            help='weight separated stats by total, i.e. non-separated, weight')
    parser.add_option('-f', '--function', metavar='STR', default=None, 
            help='kernel function to be applied to each data point in ' + \
                    'Python notation w/ a placeholder for a float, e.g. ' + \
                    "'sin(%f) / (2 * pi)'")
    parser.add_option('-i', '--import-math', metavar='CSV', default=None, 
            help='functions that need to be imported from the math-module ' + \
                    'for the evaluation of the kernel function, e.g. ' + \
                    "'--import-math=\"sin,cos\"'")
    parser.add_option('-o', '--output', metavar='FILE', default=None,
            help='write output to FILE (default: STDOUT)')
    parser.add_option('--verbose', action='store_true', default=False,
            help='display additional information while running')
    parser.add_option('--debug', action='store_true', default=False, 
            help='run in debug mode, i.e. maximum information')

    options, args = parser.parse_args()

    # set logger format etc.
    logging.basicConfig(level=logging.WARNING, format='%(levelname)s ' + \
            '%(message)s @ %(asctime)s %(module)s line %(lineno)s',
            datefmt='%H:%M:%S')
    # set logging thresholds
    if options.debug:
        logging.getLogger('').setLevel(logging.DEBUG)
    elif options.verbose:
        logging.getLogger('').setLevel(logging.WARNING)
    else:
        logging.getLogger('').setLevel(logging.CRITICAL)
    logging.debug('options: %s' % repr(options))
    logging.debug('args: %s' % repr(args))

    # redirect STDOUT?
    if options.output:
        try:
            sys.stdout = open(options.output, 'w')
        except IOError, errmsg:
            print '#', errmsg
            print '# Directing output to STDOUT instead.'

    # import math functions?
    if options.import_math:
        for f in options.import_math.split(','):
            exec('from math import ' + f)
    # process data
    for filename in args:
        print '<%s>' % filename
        xvg = XVGIO(filename)
        keys, sets = xvg.read()
        if len(xvg.legends) == len(sets):
            names = ['%s: ' % x for x in xvg.legends]
        else:
            names = ['' for x in sets]
        # limit scope?
        if options.begin is not None:
            i = 0
            while options.begin > float(keys[i]):
                i += 1
            begin = i
        else:
            begin = None
        if options.end is not None:
            i = -1
            while options.end < float(keys[i]):
                i -= 1
            end = i + 1
            if end == 0:
                end = None
        else:
            end = None
        logging.debug('(begin,end)=(%s,%s)' % (repr(begin), repr(end)))
        for name, set in zip(names, sets):
            # limit scope
            set = set[begin:end]
            # apply kernel function?
            if options.function is not None:
                for i in range(len(set)):
                    set[i] = eval(options.function % set[i])
            # calculate average and error
            n = float(len(set))
            avg = sum(array(set)) / n
            logging.debug('n=' + repr(n))
            logging.debug('avg=' + repr(avg))
            if options.deviation:
                err = sqrt(sum((array(set) - avg)**2) / (n - 1))
            else:
                err = sqrt(sum((array(set) - avg)**2) / (n * (n - 1)))
            print name + str(avg) + ' (+/- %s)' % err
            # separate?
            lo, hi = (min(set), max(set))
            if options.separate and (lo * hi) < 0.0:
                pos = []
                neg = []
                for s in set:
                    if s > 0.0:
                        pos.append(s)
                    elif s < 0.0:
                        neg.append(s)
                    else:
                        pos.append(s)
                        neg.append(s)
                n_pos = float(len(pos))
                n_neg = float(len(neg))
                if options.weight:
                    avg_pos = sum(array(pos)) / n
                    avg_neg = sum(array(neg)) / n
                else:
                    avg_pos = sum(array(pos)) / n_pos
                    avg_neg = sum(array(neg)) / n_neg
                if options.deviation:
                    err_pos = sqrt(sum((array(pos) - avg_pos)**2) / (n_pos - 1))
                    err_neg = sqrt(sum((array(neg) - avg_neg)**2) / (n_neg - 1))
                else:
                    err_pos = sqrt(sum((array(pos) - avg_pos)**2) / \
                            (n_pos * (n_pos - 1)))
                    err_neg = sqrt(sum((array(neg) - avg_neg)**2) / \
                            (n_neg * (n_neg - 1)))
                print '  ' + '(neg) ' + str(avg_neg) + ' (+/- %s)' % err_neg
                print '  ' + '(pos) ' + str(avg_pos) + ' (+/- %s)' % err_pos
 
    # the end.
    if options.output:
        sys.stdout.close()

