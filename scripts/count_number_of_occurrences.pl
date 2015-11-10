#!/usr/bin/perl
use warnings;
#use diagnostics

my(@words, %count, $word);
chomp(@words = <STDIN>);

foreach $word (@words) {
    $count{$word} += 1;
}

foreach $word (keys %count) {
    print "$word was seen $count{$word} times.\n";
}
