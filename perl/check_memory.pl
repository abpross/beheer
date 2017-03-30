#!/usr/bin/perl
use strict;
use warnings;

my $SUDO="/opt/sfw/bin/sudo";
my %memorycap;
my %memoryuse;
my $memorywarning=0;
my %memratio;
my @zonecap;
my %sharedmcap;
my %sharedmuse;
my $exitweight=0;
my %mark;
$mark{"memory"}="";
$mark{"shared"}="";
my $printout="no";

sub check_arguments { 
	##### checking the parmaters #####
	if ( $ARGV[1] ) {
		$memratio{"crit"}=$ARGV[1]/100;
	}else{ 
		die "$0 <warning> <critical> \n";
	}
	if ( $ARGV[0] ) {
		$memratio{"warn"}=$ARGV[0]/100;
	} else {
		die "$0 <warning> <critical> \n";
	}
	if ( $ARGV[2] ) { 
		if ( $ARGV[2] eq "y"){
			$printout="yes";
		}
	}
}

#check if this prgram runs with root permis
#my $loginuser=getpwuid( $< );
#die "you must be root to run $0 \n" if $loginuser ne "root";
#### counting memory ####
sub memory { 
	# get memory stat from rcapstat#
	my @memorycaptab=(`/usr/bin/rcapstat -z 1 1 `);
	@memorycaptab=grep(! /zone/, @memorycaptab);
	my @temparray;
	foreach my $line (@memorycaptab) {
		chomp $line;
		#put values to hash#
		@temparray=(split( /\ +/, $line))[2,5,6];
		#remove M  or G 
		if ( grep  /G/, $temparray[1]) {
			chop($temparray[1]);
			$temparray[1]=$temparray[1]*(1024**2)
		}
		if ( grep  /M/, $temparray[1]) {
			chop($temparray[1]);
			$temparray[1]=$temparray[1]*1024;
		}
		if ( grep  /G/, $temparray[2]) {
			chop($temparray[2]);
			$temparray[2]=$temparray[2]*(1024**2);
		}
		if ( grep  /M/, $temparray[2]) {
			chop($temparray[2]);
			$temparray[2]=$temparray[2]*1024;
		}
		# if memory use is more than 90% from cap#
		if ( $temparray[1] > ( 0.9 * $temparray[2] )) {
			$memorywarning=1;
			#$temparray[0]=$temparray[0]."*";
		}
		if ( $temparray[1] > $temparray[2] ) {
			$memorywarning=2;
			#$temparray[0]=$temparray[0]."**";
		}
		$memoryuse{ $temparray[0] } = $temparray[1]/1024;
		$memorycap{ $temparray[0] } = $temparray[2]/1024;
	}
}

sub print2screen {
	#### printing to screen if parameter 3 is y ####
	print "zone \t cap: memory \t gebruik: memory \n \n" if ( $printout eq "yes") ;
	foreach ( keys %memoryuse ) { 
		chomp $_;
		if ( $memoryuse{$_} > ( $memratio{"crit"} * $memorycap{$_})) {
			$mark{"memory"}="!";
			$exitweight=$exitweight+100;
			push(@zonecap, $_);
		}elsif ( $memoryuse{$_} > ( $memratio{"warn"} * $memorycap{$_})) {
			$mark{"memory"}="*";
        		$exitweight=$exitweight+1;
			push(@zonecap, $_);
        	}else{	
			$mark{"memory"}="";
        	}
		print "$_ :  cap: $memorycap{$_} \t gebruik: $memoryuse{$_} $mark{'memory'}  \n" if ( $printout eq "yes") ;
	}
}

sub nagios {
	####return data to nagios####
	# sort errors
	my %hashTemp = map { $_ => 1 } @zonecap;
	@zonecap = sort keys %hashTemp;
	if ( $exitweight > 99 ) {
		print "CRITICAL zones: @zonecap  memory > ".100*$memratio{'crit'}."% in use \n";
		exit(2);
	} elsif ( $exitweight > 0 ) {
		print "WARNING zones: @zonecap  memory  > ".100*$memratio{'warn'}."% in use \n";
	 	exit(1);
	}else{
		print "OK memory \n";
		exit(0);
	}
}


check_arguments;
memory;
print2screen;
nagios;
