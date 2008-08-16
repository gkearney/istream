#!/usr/bin/perl
 
use warnings;

BEGIN { 
    
    unshift @INC, dirname($0);

    use File::Basename;
}

$myhome = dirname($0);
$ffmpeg = "$myhome/ffmpeg";
$sox = "$myhome/sox";
$decrypt = "$myhome/decrypt";


opendir(DIR, $ARGV[0]) or die $!;

while ($file = readdir(DIR))
{
	$_ = $file;
	$song = basename($_);
	$song =~ s/\..+//g;


	next if ($file =~ m/^\./);
	next if ($file =~ m/\.mp3$/i);
	next if ($file =~ m/\.wav$/i);
	
	if  ($file =~ m/\.au$|\.aif$|\.aiff$|\.avi$|\.3gp$|\.ogg$|\.wav$|\.flc$/i)  {
	`$sox '$ARGV[0]/$_' '$ARGV[0]/$song.mp3'`;
	`rm '$ARGV[0]/$file'`;
	}
	# it is an m4p or title
	if  ($file =~ m/\.m4p$/i)  {
		`$decrypt '$ARGV[0]/$_' '$ARGV[0]/$song.m4a'`;
		`$ffmpeg -i '$ARGV[0]/$song.m4a' '$ARGV[0]/$song.mp3'`;
		`rm '$ARGV[0]/$file'`;
		`rm '$ARGV[0]/$song.m4a'`;
	}
	#it is a m4a title
	if  ($file =~ m/\.m4a$|\.mov$|\.m4b$/)  {
		#`$decrypt '$ARGV[0]/$_' '$ARGV[0]/$song.m4a'`;
		`$ffmpeg -i '$ARGV[0]/$_' '$ARGV[0]/$song.mp3'`;
		`rm '$ARGV[0]/$file'`;
		#`rm '$ARGV[0]/$song.m4a'`;
	}
	
}
close(DIR); # implicit.