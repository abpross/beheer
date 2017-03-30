#!/usr/bin/perl
use warnings;
use strict;
use subperl;

my $result = subperl->testsub(2,100,3);
print "$result \n" ;
my @harray=qw( 1 4 2 6 3 );
print "@harray \n";
$result = subperl->sortarray(@harray);
print "$result \n" ;
