#!/usr/bin/perl
use strict;
use warnings;


my %memorycap;
my %memoryuse;
my $memorywarning=0;
my %sharedmcap;
my %sharedmuse;
#my $loginuser=getpwuid( $> );
print getlogin,"\n";
$<=getpwnam(getlogin);
print "$>\n";
print "$<\n";
#$loginuser=getpwuid( $< );
#print $loginuser."\n";
#$< = $>;
#$loginuser=getpwuid( $< );
#print $loginuser."\n";
