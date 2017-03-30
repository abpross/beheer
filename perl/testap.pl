#!/usr/bin/perl
use warnings;
use strict;
my @ap= grep ( !/emcpower/ && ! /GK/, `syminq  ` ) ;
print "@ap \n" ;
