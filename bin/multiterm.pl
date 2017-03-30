#!/usr/bin/perl
use strict;
use warnings;
my @hosts;
#vnn@hosts=("10.10.1.143","10.10.1.144","10.110.200.171","10.110.200.172","10.110.200.173","10.110.200.174","10.110.200.175","10.110.200.176");
my $title="Pro";
my $network="10.10.10.0";
$network = substr($network,0, -2);
#aantal terms
my $windows=8;
$windows=@hosts if ( @hosts );
#sub ipadres  start met
my $starthost=11;
my $pos;
my @pos2d;
my @size2d;
if ( ! @hosts )  {
	for (my $count=0; $count <= $windows; $count++) {
		my $hostnr=$starthost+$count;
		my $ip="$network.$hostnr";
		push @hosts, $ip;	
	}
}
print "@hosts\n";

if ($windows < 7) { 
	$pos2d[$windows]=[('100+0','1000+0','100+400','1000+400','100+800','1000+800')] if ($windows < 7);
	$size2d[$windows]="125x20";
}else{
	$pos2d[$windows]=[('100+0','1000+0','100+300','1000+300','100+600','1000+600','100+900','1000+900')];
	$size2d[$windows]="125x15";
}
for (my $termnr=1; $termnr <= $windows; $termnr++) {
	$pos=$termnr-1;
	#print $pos;
	#print "termnr $termnr windows $windows j $pos size $size2d[$windows] pos $pos2d[$windows][$pos] hosts $hosts[$pos]\n";
	system ("/usr/bin/xfce4-terminal --geometry=".$size2d[$windows]."+".$pos2d[$windows][$pos]." --title ".$title."_".$hosts[$pos]." -e \"ssh ".$hosts[$pos]."\"\n") if ($windows < 9 );
	#print "/usr/bin/xfce4-terminal --geometry=".$size2d[$windows]."+".$pos2d[$windows][$pos]." --title ".$title."_".$hosts[$pos]." -e \"ssh ".$hosts[$pos]."\"\n" if ($windows < 9 );
}
