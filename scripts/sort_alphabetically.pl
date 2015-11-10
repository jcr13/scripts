#!/usr/bin/perl
#use warnings;
#use diagnostics

@lines = qw/ fred betty barney dino wilma pebbles bamm-bamm /;
@sorted = sort(@lines);
foreach $sorted (@sorted) {
    $sorted .= "\n";
}
print @sorted;
