#!/usr/bin/perl -w
$browser_list="NS:IE:Opera";
@browsersub=split(/:/, $browser_list);
$browser[1]= \@browsersub;
print $browser[1][1]."\n";

