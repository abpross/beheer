#!/usr/bin/perl
use warnings;
use strict;
use Image::ExifTool;

my $exifTool = new Image::ExifTool; 
$exifTool->Options(Unknown => 1); 

opendir(DIR, '.') ;
my @files=readdir(DIR);
close(DIR);


foreach my $imagefile (@files){
	next if $imagefile !~m/\.jpg$|\.cr2$/i;
	my $streeppos= index($imagefile, "_");
	next if $streeppos < 1;
	my $puntpos= index($imagefile, ".", $streeppos);
	my $indexnummer= substr $imagefile,($streeppos + 1), ($puntpos-$streeppos)-1 ;
	my $info = $exifTool->ImageInfo($imagefile) ; 
	next if ! $info->{"CreateDate"} ; # check if exif info exist#
	(my $ExifDate, my $ExifTime)= split( /\ /, $info->{"CreateDate"});
	my $filetype=$info->{"FileType"};
	my $filename=$info->{"FileName"};
	my $fileextention;
	if ($filetype eq "CR2") {
		$fileextention="cr2";
	} elsif ($filetype eq "JPEG") {
		$fileextention="jpg";
	}else{
		next;
	}
	$ExifDate=~s/://g;
	my $newfilename="APRS".$ExifDate."_".$indexnummer.".".$fileextention;
	if ( -e $newfilename ){
		print "skipping ".$newfilename." file exist \n" ; 
		next;
	}
	print "rename $filename to $newfilename \n";
	rename($filename, $newfilename);
}
