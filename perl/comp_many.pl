#!/usr/bin/perl 
#use strict;
#use warnings;

my $f1 = "list1";
my $f2 = "list2";
my $f3 = "list3";
my $f4 = "list4";
my $f5 = "list5";
my $f6 = "list6";
my $f7 = "list7";
my $outfile = "./compare_1-7.txt";
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

open FILE4, "$f4" or die "could not open file: $! \n";
while(my $line = <FILE4>) {
$results{$line}++;
}
close(FILE4);

open FILE5, "$f5" or die "could not open file: $! \n";
while(my $line = <FILE5>) {
$results{$line}++;
}
close(FILE5);

open FILE6, "$f6" or die "could not open file: $! \n";
while(my $line = <FILE6>) {
$results{$line}++;
}
close (FILE6);

open FILE7, "$f7" or die "could not open file: $! \n";
while(my $line = <FILE7>) {
$results{$line}++;
} close (FILE7); 

open (OUTFILE, ">$outfile") or die "Cannot open $outfile for writing \n";

foreach my $line (keys %results) { 
print OUTFILE $line if $results{$line} >= 4;
}
close OUTFILE;

