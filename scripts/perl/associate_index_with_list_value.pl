#!/usr/bin/perl
#use warnings;
#use diagnostics
#This takes STDIN and associates a name on the list according to index and prints them out.

print "Enter 4 numbers between 0-6 (one per line) and press ^D after all 4 have been entered.\n";
@lines = qw/ fred betty barney dino wilma pebbles bamm-bamm /;
foreach $index (<STDIN>) {
    print "$lines[$index]\n";
}
