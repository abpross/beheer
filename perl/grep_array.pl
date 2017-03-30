#!/usr/bin/perl
use strict;
use warnings;

my @tabel = qw( jan piet jans pietje);
my @result= grep /\bjan\b/ , @tabel ;
print "@result /n";
