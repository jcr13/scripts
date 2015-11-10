#!/usr/bin/perl
use warnings;

print "What is number one?\n";
chomp($one = <STDIN>);
print "What is number two?\n";
chomp($two = <STDIN>);
$result = $one * $two;
print "The result is $result.\n";
