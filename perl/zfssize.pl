#!/usr/bin/perl
use warnings;
use strict;
my $warning = $ARGV[0];
my $critical= $ARGV[1];
my @diskavail;
my %hasch;
@diskavail=`zfs get -H -p  available`;
@diskavail=(grep /zoneroot/ & ! /\@/ ,@diskavail);
 foreach ( @diskavail ) {
	(my $element,my $elementn)=(split /\t+/ ,$_ )[0,2];
	$hasch{ $element } = $elementn; 
	if ( $hasch{ $element } < $warning ){
		print "$element $hasch{ $element } < warning $warning \n"
	}

}
#for my $key ( keys %hasch ) {
#        my $value = $hasch{$key};
#        print "$key => $value\n";
#    }



