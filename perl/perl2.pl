#!/usr/bin/perl
$b=10;
$s=40;
$a=$b+$s;

print "$a \n";
$DIRECT="/tmp";
chdir $DIRECT  or die "dir $DIRECT does exist \n";
$PWD = `pwd`;
print "$PWD \n";
#for ( $count = 1; $count < 100; $count++) {
# print "$count \n"; 
#	sleep 1;
#}
#; 
open(DATA, ">tmp.txt");
print DATA "test \n";
close (DATA)
