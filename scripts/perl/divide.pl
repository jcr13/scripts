#!/usr/bin/perl
#use warnings;
#use diagnostics

sub division {
    $_[0] / $_[1];
}

my $quotient = division (<STDIN>);
print "$quotient\n";
