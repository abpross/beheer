#!/usr/bin/perl
use strict;
use warnings; 

sub random_array { 
	my $count;
	my @val;
	while ( scalar @val < 100 )
	{
 		my $random=int(rand(100));
		push @val, $random if ( @val == 1 ); 
		my $x=0;
		foreach my $i (@val){
  			$x=1 if ( $i == $random ) ;
		}
		push ( @val, $random ) if $x==0 ;
	} 
	return @val;
}
my @AP=random_array;
print "@AP \n"; 
