#!/usr/bin/perl
use warnings;
use strict;
my %auto ;
$auto{seat}{olie} = '20w40';
foreach  (key %auto{seat}) {
	print $_,"\n";
}
:wq
