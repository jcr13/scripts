#!/usr/bin/perl
#use warnings;
#use diagnostics

sub list {
    if ($a < $b) {
    $a..$b;
} else {
    reverse $b..$a;
    }
}

$a = 6;
$b = 11;
@c = &list;
foreach $_(@c) {
    $_ .= "\n";
}
print @c;
