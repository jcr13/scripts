#!/usr/bin/perl
#use warnings;
#use diagnostics

#Uses &total to sum @fred
my @fred = qw/ 1 3 5 7 9 /;
my $fred_total = total(@fred);
print "The total of \@fred is $fred_total.\n";

#Uses &total to sum STDIN
print "Enter some numbers on separate lines: ";
my $user_total = total(<STDIN>);
print "The total of those numbers is $user_total.\n";

#Uses &total to sum 1 to 1000 (500500)
my $math_total = total (1..1000);
print "The total of 1 to 1000 summed is $math_total\n";

sub total {
    my $sum;
    foreach (@_) {
	$sum += $_;
    }
    $sum;
}
