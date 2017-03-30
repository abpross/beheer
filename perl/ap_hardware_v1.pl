#!/usr/bin/perl
use warnings;
use strict;
system("clear");
#-- check if running as root
if ( $< != 0 ){
	die "please Run as root!!\n";
}
my @processor;
 my @processor_count;
my $manufactory=(`/usr/sbin/dmidecode | grep "Product Name"`);
$manufactory=~ s/Product Name://g;
my $MemTotal=(split /\ +/, `grep MemTotal /proc/meminfo`)[1];
$MemTotal=int(($MemTotal/(1024**2)) + 0.5);

print "manufactory: ",$manufactory,"\n";
print "Memory: $MemTotal GB \n";
if ($manufactory !~ /VMware/) {
	@processor=split /\n/ , `/usr/sbin/dmidecode -s processor-version`;
	@processor_count=split /\n/, `/usr/sbin/dmidecode -t processor | grep "Core Count"`;  
	print "processors: \n" ;
	for (my $count=0; $count<@processor; $count++){
		print "$processor[$count] $processor_count[$count] \n"; 
	}
}

my $disk=`/sbin/fdisk -l  2>/dev/null | grep -v dm | grep "B,"`;
print "\n\nHarddisks: \n";
print "$disk \n";
