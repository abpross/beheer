#!/usr/bin/perl
use strict;
use warnings;
#use diagnostics;
my @lot1= qw(andre robin mark daniel annette kelly leonie);
my $countloop=0;
my %pares;
my $nogo=1;
my @AP;
my @old_list;
%pares=('andre' => 'annette', 'annette' => 'andre',
 'robin' => 'kelly', 'kelly' => 'robin',
 'mark' => 'leonie', 'leonie' => 'mark',
 'daniel' => 'daniel', 'daniel' => 'daniel' );
sub get_oldresult {
        if ( -r 'sntlist.txt' ) {
                open(MYFILE, '<sntlist.txt');
                @old_list=<MYFILE>;
                chomp @old_list;
                close(MYFILE);
        }
 }
 close (MYFILE);

sub random_array {
        my $count;
        my @val;
        my $max=$_[0];
        while ( scalar @val < $max )
        {
                my $random=int(rand($max));
                push @val, $random if ( @val == 0 );
                my $x=0;
                foreach my $i (@val){
                        $x=1 if ( $i == $random ) ;
                }
                push ( @val, $random ) if $x==0 ;
        }
        return @val;
}
sub conrole_paren {
        while ($nogo == 1) {
                @AP=random_array  (scalar @lot1) ;
                my $fout=0;
                foreach my $arayid ( 0..((@lot1)-1)){
                        $fout=1 if $lot1[$AP[$arayid]] eq $pares{$lot1[$arayid]} ;
                        $fout=1 if $lot1[$AP[$arayid]] eq $lot1[$arayid] ;
                        ## kijken of die niet in de oude lijst als de array bestaat voorkom.
                        if (scalar @old_list => ((scalar @lot1))  ) {
                        foreach my $element (@old_list) {
                                chomp $element;
                                #print "$lot1[$arayid] $lot1[$AP[$arayid]] \t $element\n" ;
                                $fout=1 if "$lot1[$arayid] $lot1[$AP[$arayid]]" eq "$element";
                        }
                        }
                }
                $nogo=0 if $fout == 0 ;
                if ( $countloop == 10000 ) {
                        print  "10000 keer geprobeerd, er wordt nieuwe lijst sntlist.txt aangemaakt \n";
			if (unlink('sntlist.txt') == 0) {
    				die  "sntlist.txt verwijderd \n";
			} else {
    				die  "sntlist.txt was niet te verwijderen.\n";
			}

                }else{
                        $countloop++ ;
                }
        }
}

sub print_out {
        open (MYFILE, '>>sntlist.txt');
        foreach ( 0..((@lot1)-1)){
                print MYFILE "$lot1[$_] $lot1[$AP[$_]]\n";
        }
        close (MYFILE);
}

## start real program ##
get_oldresult;
conrole_paren;
print_out;
