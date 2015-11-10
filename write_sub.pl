#!/usr/bin/perl -w

use strict;

# opens a generic .sub and changes the time variable by 1ns and jobid
# usage: "perl write_sub.pl em.sub" where em.sub is template for submitting to ember
# things to edit for each use: $i here is set to write .sub from 2000 to 1000000 at 1000 intervals
# the jobid variable should be changed, here it is 105827

unless (@ARGV) {
    die "Usage: $0 input.sub\n";
}

my $sub = $ARGV[0];

my @temp = split('\.', $sub);
my $base = $temp[0];

open(IN, "<$sub");
my @in = <IN>;
close(IN);

for (my $i=2000; $i<101000; $i+=1000) {

    my $filename = "${base}_${i}.sub";

    open(OUT, ">$filename");

    foreach $_ (@in) {
        unless (($_ =~ /^setenv TIME 2000$/) || ($_ =~ /^setenv NEXT 3000$/) || ($_ =~ /#PBS -N jobid$/)) { 
            print OUT $_;
        }

	if ($_ =~ /#PBS -N jobid$/) {
	    print OUT "#PBS -N 105827_$i\n";
    	}

        if ($_ =~ /^setenv TIME 2000$/) {
            if ($i<101000) {
                print OUT "setenv TIME $i\n";
            } 
        }

        
        if ($_ =~ /^setenv NEXT 3000$/) {
            if ($i<100000) {
                print OUT "setenv NEXT ",$i+1000,"\n";
            }
        }
    }

    close(OUT);

}

exit;
