#!/usr/bin/perl
use strict;
use warnings;
my @zones=(grep !/global/, `/usr/sbin/zoneadm list`);
chomp @zones;
print $zones[0]," \n" ;
my @zfslist=`zfs list -H /zones/@zones`;
chomp @zfslist;
print @zfslist," \n" ;

#xargs  -I {} zfs list -H /zones/{} | awk ' { print $ackup" }' | xargs  -I {} zfs list -H  {} ; echo $?
