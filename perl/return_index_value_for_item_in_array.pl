#!/usr/bin/perl
#use warnings;
#use diagnostics
#learning perl p. 74 (subroutine stops when value is returned)

my @names = qw/ fred barney betty dino /;
my $result = &which_is("dino", @names);
print "$result\n";

sub which_is {
    my($what, @array) = @_;
    foreach (0 .. $#array) {
	if ($what eq $array[$_]) {
	    return $_;
	}
    }
    undef;
}
