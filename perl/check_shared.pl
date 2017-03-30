#!/usr/bin/perl
use strict;
use warnings;

my $SUDO="/opt/sfw/bin/sudo";
my $zone;
my %memratio;
my @zonecap;
my %sharedmcap;
my %sharedmuse;
my $exitweight=0;
my %mark;
$mark{"memory"}="";
$mark{"shared"}="";
my @runningzones;
my @zones;
my $printout="no";

sub check_arguments {
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

sub round ($){ 
	int($_[0] + 0.5)
	}

# counting sharedmemory #
sub sharedmem { 
	# get shared stat from rcapstat#
	my $shared=0;
	### getting the zone names
	@runningzones=(grep( ! /NAME|global/,  ` /usr/sbin/zoneadm list -v `)) ;
	chomp @runningzones;
	foreach  (@runningzones) {
		$zone=(split(/\ +/, $_ ))[2];
		chomp $zone;
		### getting shareduse
		my @temparray=`ipcs -am -z $zone`;
		chomp @temparray;
		@temparray=(grep /^m/, @temparray);
		$shared=0;
		foreach (@temparray){
			my $sharedsize=((split( /\ +/, $_))[9]);
			$shared=$shared+$sharedsize;
		}
		##### if no shared memory is set, skip this zone
		next if  $shared==0 ;
		push (@zones, $zone);
		$sharedmuse{$zone}=round($shared/(1024**2));
		### getting sharedcap
		my @prctl=`$SUDO prctl -P -n zone.max-shm-memory -t privileged -i zone $zone`;
		chomp  @prctl;
		my $prctline=(grep /zone.max-shm-memory/, @prctl)[0];
		$sharedmcap{$zone}=round(((split / +/, $prctline )[2])/(1024**2));		
		#print "$zone $sharedmuse{$zone}  $sharedmcap{$zone} \n";
	}
}



sub print2screen {
	print "zone \t cap: shared \t gebruik: shared \n \n" if ( $printout eq "yes") ;
	foreach ( @zones ) { 
		chomp $_;
		if ( $sharedmuse{$_} > ( $memratio{"crit"} * $sharedmcap{$_})) {
			$mark{"shared"}="!";
			$exitweight=$exitweight+100;
			push(@zonecap, $_);
		}elsif   ( $sharedmuse{$_} > ( $memratio{"warn"} * $sharedmcap{$_})) {
			$mark{"shared"}="*";
			$exitweight=$exitweight+1;
			push(@zonecap, $_);
		}else{
			$mark{"shared"}="";
		}
		print "$_ :  cap: $sharedmcap{$_} \t gebruik: $sharedmuse{$_} $mark{'shared'} \n" if ( $printout eq "yes") ;
	}
}
sub nagios {
	####return data to nagios
	#
	## sort errors
	my %hashTemp = map { $_ => 1 } @zonecap;
	@zonecap = sort keys %hashTemp;
	if ( $exitweight > 99 ) {
		print "CRITICAL zones: @zonecap  sharedmem > ".100*$memratio{'crit'}."% in use \n";
		exit(2);
	} elsif ( $exitweight > 0 ) {
		print "WARNING zones: @zonecap  sharedmem > ".100*$memratio{'warn'}."% in use \n";
	 	exit(1);
	}else{
		print "OK shared memory \n";
		exit(0);
	}
}



#### Start Program ### 
check_arguments;
sharedmem;
print2screen;
nagios;
