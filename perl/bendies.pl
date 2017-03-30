#!/usr/bin/perl
use warnings;
use strict;
my $dies=1.21;
my $benz=1.51;
my $beldies=1392;
my $belbenz=632;
my $verbdies=17;
my $verbbenz=11.5;


my $km=($beldies-$belbenz)/(( $benz/$verbbenz)-($dies/$verbdies));
#print "$km=($beldies-$belbenz)/(( $benz/$verbbenz)- ($dies/$verbdies))\n";
print "berekening kantelpunt bij : \n
               \t\tdiesel\tbenzine
prijs brandstof\t\t$dies\t$benz
      belasting\t\t$beldies\t$belbenz
verbruik 1liter\t\t$verbdies\t$verbbenz

";
printf(	"kantelpunt %.0f km \n",$km );

