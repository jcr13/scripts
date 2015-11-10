#!/usr/bin/perl
use warnings;
#use diagnostics
use perl;

@Llist = qw(abel abel baker camera delta edward fargo golfer);
@Rlist = qw(baker camera delta delta edwrad fargo golder hilton);

$lc = List::Compare->new(\@Llist, \@Rlist);

@intersection = $lc->get_intersection;
@union = $lc->get_union;

print "@intersection\n";
