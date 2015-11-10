#!/usr/bin/perl -w

use strict;

# opens a generic .cfg and changes the time
# by 1ns increments

unless (@ARGV) {
    die "Usage: $0 input.cfg\n";
}

my $cfg = $ARGV[0];

my @temp = split('\.', $cfg);
my $base = $temp[0];

open(IN, "<$cfg");
my @in = <IN>;
close(IN);

for (my $i=1000; $i<101000; $i+=1000) {

    my $filename = "${base}_${i}.cfg";

    open(OUT, ">$filename");

    foreach $_ (@in) {
        unless (($_ =~ /^time = 1000.0$/)) {
            print OUT $_;
        }

        if ($_ =~ /^time = 1000.0$/) {
            printf OUT "time = $i.0\n";
        }
	
    }

    close(OUT);

}

exit;
