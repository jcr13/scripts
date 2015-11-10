#!/usr/bin/perl -w
#use diagnostics;
#use strict;

@array = (1..5801);
foreach $_ (@array) {
    $_ .= "\n";
}
open LIST, '>list.txt';
select LIST;
print "\n", @array;
