#!/usr/bin/perl
use strict;
use warnings;
use File::Find;
my $filesearch=$ARGV[1];
my $dir1=$ARGV[0];
die "no arguments find.pl [dir][file] \n" if ( ! $dir1 ) ; 
if ( ! $filesearch ){
$filesearch=$dir1;
$dir1=".";
};

find(\&wanted, $dir1);

sub wanted {
	print "$File::Find::dir/$_\n" if /$filesearch/i ;

}


