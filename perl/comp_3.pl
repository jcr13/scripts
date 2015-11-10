#!/usr/bin/perl 
#use strict;
#use warnings;

my $f1 = "list1.txt";
my $f2 = "list2.txt";
my $f3 = "list3.txt";
my $outfile = "./compare_1-3.txt";
my %results = ();

open FILE1, "$f1" or die "could not open file: $! \n";

while(my $line = <FILE1>){   
$results{$line}=1;
}
close(FILE1);

open FILE2, "$f2" or die "Could not open file: $! \n";

while(my $line = <FILE2>) {  
$results{$line}++;
}
close(FILE2);  

open FILE3, "$f3" or die "could not open file: $! \n";
while(my $line = <FILE3>) {
$results{$line}++;
}
close(FILE3);

open (OUTFILE, ">$outfile") or die "Cannot open $outfile for writing \n";

foreach my $line (keys %results) { 
print OUTFILE $line if $results{$line} >= 3;
}
close OUTFILE;

