#!/usr/bin/perl
use warnings;
use strict;
my %dev;
my %powerdev;
my @tmparray;
my @symetrics;
my @sympdlist;
my @emcdev_wwn=grep /emcpower/  , `syminq -wwn `;
chomp @emcdev_wwn;
my @emcdev=grep /emcpower/  , `syminq`;
chomp @emcdev;
@emcdev=grep /GK/, @emcdev;
foreach (@emcdev_wwn){
	@tmparray=(split /\ +/, $_ )[0,1,2];
	chomp @tmparray;
	$tmparray[0]=substr $tmparray[0], 10;
	my @GK=(grep /$tmparray[0]/, @emcdev);
	next if (@GK);
	if ( ! grep /$tmparray[2]/, @symetrics ){
		push @symetrics, $tmparray[2];
	}
	$powerdev{ ( $tmparray[0] )}=$tmparray[1];
}

if ( @symetrics > 1 ) {
	print "letop meer dan een symetrics: @symetrics \n";
}

foreach my $sid ( @symetrics ) {
	push @sympdlist, (grep( /^c/ & ! /emcpower/ , `sympd  -sid $sid  list `)) ;
}
chomp @sympdlist;

foreach (@sympdlist) { 
	@tmparray=(split( /\ +/, $_ ))[1,2];
	chomp @tmparray;
	if (  $dev{ ($tmparray[0]) } eq ""  ) {
		$dev{ ($tmparray[0]) } = $tmparray[1];
	}elsif (  ! grep /($tmparray[1])/, $dev{ ($tmparray[0]) } ) {
		$dev{ ($tmparray[0]) } = $dev{ ($tmparray[0]) }." ".$tmparray[1];
	}
}

foreach ( keys %powerdev ) {
	my $lun=$powerdev{$_ } ;
	my $ap=$dev{($lun)};
	if ($ap) {
	print "$_ $lun $ap   \n";
	}else{
	print "$_ $lun \n";
	}

}
