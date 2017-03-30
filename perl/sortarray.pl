#!/usr/bin/perl 
use strict;
use warnings;

my @array = ('Apple', 'Orange', 'Apple', 'Banana');
print "@array \n";
my %hashTemp = map { $_ => 1 } @array;
my @array_out = sort keys %hashTemp;
print "@array_out \n"; 

my @numarray=('12','1','8','7','9','3');
my @sorted = sort { $a <=> $b } @numarray;
print "@sorted \n"; 

