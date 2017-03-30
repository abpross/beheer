#!/usr/bin/perl
use strict;
use warnings;

my $totalswapcur=0;
my $totalswapcap=0;
my $SUDO="/opt/sfw/bin/sudo";
my $zone;
my $id;
my %memratio;
my @zonecap;
my %swapcap;
my %swapuse;
my $exitweight=0;
my %mark;
$mark{"memory"}="";
$mark{"shared"}="";
my @runningzones;
my @zones;
my $printout="no";

sub check_arguments {
	#### checking the parameters ####
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

# counting swap memory  #
sub swapmem { 
	my $swapcap=0;
	my $swapcur=0;
	# get shared stat from rcapstat#
	my $shared=0;
	### getting the zone names
	@runningzones=(grep( ! /NAME|global/,  ` /usr/sbin/zoneadm list -v `)) ;
	chomp @runningzones;
	foreach  (@runningzones) {
		($zone,$id)=(split(/\ +/, $_ ))[2,1];
		chomp $zone;
    		# Current swap cap
    		#
		$swapcap=(grep( /privileged/,`$SUDO prctl -P -n zone.max-swap -t privileged -i zone $zone`))[0];
		next if (! $swapcap );
		# get third field
		$totalswapcap=(split( /\ +/,$swapcap))[2]/(1024**2);
		$swapcur=(grep( /caps/, `kstat -p caps:$id:swapresv_zone_$id:usage`))[0];
		# get second field
		$totalswapcur=(split( /\ +|\t/, $swapcur))[1]/(1024**2);
		next if  $totalswapcur==0 ;
		push (@zones, $zone);
		$swapuse{$zone}=round($totalswapcur);
		$swapcap{$zone}=round($totalswapcap);
	}
}

sub print2screen {
	#### print to screen if parameter 3 is y ####
	### first print header ##
	print "zone \t\t cap: shared \t gebruik: shared \n \n" if ( $printout eq "yes") ;
	#### print values ####
	foreach ( @zones ) { 
		chomp $_;
		if ( $swapuse{$_} > ( $memratio{"crit"} * $swapcap{$_})) {
			$mark{"shared"}="!";
			$exitweight=$exitweight+100;
			push(@zonecap, $_);
		}elsif   ( $swapuse{$_} > ( $memratio{"warn"} * $swapcap{$_})) {
			$mark{"shared"}="*";
			$exitweight=$exitweight+1;
			push(@zonecap, $_);
		}else{
			$mark{"shared"}="";
		}
		print "$_ : \t\t cap: $swapcap{$_} \t gebruik: $swapuse{$_} $mark{'shared'} \n" if ( $printout eq "yes") ;
	}
}



sub nagios {
	####return data to nagios ####
	#
	## sort errors
	my %hashTemp = map { $_ => 1 } @zonecap;
	@zonecap = sort keys %hashTemp;
	if ( $exitweight > 99 ) {
		print "CRITICAL zones: @zonecap  swap > ".100*$memratio{'crit'}."% in use \n";
		exit(2);
	} elsif ( $exitweight > 0 ) {
		print "WARNING zones: @zonecap  swap > ".100*$memratio{'warn'}."% in use \n";
	 	exit(1);
	}else{
		print "OK swap  \n";
		exit(0);
	}
}



#### Start Program ### 
check_arguments;
swapmem;
print2screen;
nagios;
