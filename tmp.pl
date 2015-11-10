#!/usr/bin/perl
#use warnings;
#use diagnostics

my $filename = 'data.txt';
if (open(my $fh, '<', $filename)) {
} else {
  warn "Could not open file '$filename' $!";
}
#-ne 'print; exit';
