#!/usr/bin/perl
#use strict;
use warnings;
(my $year, my $mon, my $mday)=(localtime(time))[5,4,3];
#my $datum=(printf "%02d-%02d-%04d\n",$mday,$mon,($year+1900));
#                        open (MYFILE, ">>ap.ok");
#                                print MYFILE $datum;
#                        close (MYFILE); 


my $ymd=sub{sprintf '%02d-%02d-%04d', $_[3], $_[4]+1, $_[5]+1900}->(localtime);
print $ymd."\n" ;

