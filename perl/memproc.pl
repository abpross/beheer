#!/usr/bin/perl
use warnings;
use strict;
my @proc=(`ps -efZ` grep 'advh' )[1];
print @proc;

