#!/usr/bin/perl
use warnings;
use strict;
use Image::ExifTool;

my $exifTool = new Image::ExifTool; 
$exifTool->Options(Unknown => 1); 
my $info = $exifTool->ImageInfo('a.jpg'); 
my $group = ''; 
my $tag; 
foreach $tag ($exifTool->GetFoundTags('Group0')) { 
	if ($group ne $exifTool->GetGroup($tag)) { 
		$group = $exifTool->GetGroup($tag); 
		print "---- $group ----\n";
 	} 
	my $val = $info->{$tag}; 
	if (ref $val eq 'SCALAR') { 
		if ($$val =~ /^Binary data/) { 
			$val = "($$val)"; 
		} else { my $len = length($$val); 
			$val = "(Binary data $len bytes)"; 
		} 
	} 
	print $tag ;
	printf("%-32s : %s\n", $exifTool->GetDescription($tag), $val);
}


