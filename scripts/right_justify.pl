#!/usr/bin/perl
use warnings;
#use diagnostics

chomp(my @lines = <>);

foreach (@lines) {
    printf "%67s\n", $_;
}
