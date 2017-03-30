#!/usr/bin/perl -w
$x=0;
$tot=0;
$i=0;
foreach my $parm (@ARGV)
{
  print "parameter $i: ",$ARGV[$i],"\n";
  $i++;
}

$LOGFILE =$ARGV[0];
open(LOGFILE) or die("Could not open log file.");
foreach $line (<LOGFILE>) {
    
    ($protect, $countf, $name, $group, $size,
         $month, $day, $year_time, $file) = split(' ',$line);
    # do line-by-line processing.
    @regel=($protect, $countf, $name, $group, $size, $month, $day, $year_time, $file);
  $mijntabel[$x]=[ @regel ];
  $x=$x+1;
}
close(LOGFILE);
$x=$x-1;
$i=0;
for $i (0..$x) {
$tot=+$mijntabel[$i][4];
};
print $tot."\n";
