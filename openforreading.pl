#!/usr/bin/perl
use strict;
use warnings;
use 5.010;


my $filename = 'data.txt';
if (open(my $fh, '<', $filename)) {
  while (my $row = <$fh>) {
    chomp $row;
    say $row;
  }
} else {
  warn "Could not open file '$filename' $!";
}
