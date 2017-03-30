#!/usr/bin/perl
use Switch;

$i;
chomp($var=<STDIN>);

switch ($var){
  case(1) { $i = "One"; }
  case(2) { $i = "Two"; }
  case(3) { $i = "Three"; }
  else    { $i = "Other"; }
}

print "case: $i\n";

