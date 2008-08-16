#!/usr/bin/perl -w



# Declare the subroutines
sub trim($);
sub ltrim($);
sub rtrim($);
# Interface 
BEGIN { 
	use File::Basename;
	unshift @INC, dirname($0);
	use File::Copy;
}
#use strict;

# The user interface


	$daisyout = $ARGV[1];
	$daisyin = $ARGV[0];
	$daisyin =~ s/ /\\ /g;
	$daisyout =~ s/ /\\ /g;
	
	



our $title = "";


#$daisyin = `$CD fileselect --text "Select the Daisy book directory" --select-only-directories`;
if ($daisyin eq "") {exit;}
#$daisyout = `$CD fileselect --text "Select the destination location" --select-only-directories`;
if ($daisyout eq "") {exit;}

if ($daisyin ne "" and $daisyout ne "") {
	$daisyin = rtrim($daisyin);
   	$ncc = $daisyin . "/ncc.html";
   	chomp($ncc);
   	$cmd = "/usr/bin/grep -iE '<title>(.+)</title>' $ncc";
  	$_ = `$cmd`;
  	
  	if ($_ ne ""){
  	
   		#m<title>(.+)</title>#gi;
   		$title = $1;
   	} else {
   		
   		$ncx = $daisyin . "/*.ncx";
   		chomp($ncx);
   		$cmd = "/usr/bin/grep -iE '<title>(.+)</title>' $ncx";
  		$_ = `$cmd`;
  		#m<title>(.+)</title>#gi;
  		$title = $1;
   	}
   	
   	
   	
   	if ($title eq "") {
   		print "Could not find book title, can not copy.";
   		exit;
   	
   	} else {
   	
   		$_ = $title;
		
   		s/'|:|\///gi;
   		s/\s/_/gi;
		
   		$daisyout = rtrim($daisyout);
   		$dirname = $daisyout . "/" . $_;
		$dirname =~ s/\$/\\\$/g;
		#print "$dirname\n\n\n";
   		`mkdir $dirname`;
		
   		$cmd = "cp $daisyin/*.* $dirname";
		
		#print "\n\n\n$cmd\n\n\n";
		#$cmd = "rsync -av $daisyin $dirname";
   		`$cmd`;
   		print "Copy of $title is installed.";
   }
} else {

    exit;
}
		
		
		
		
		
sub ltrim($)
{
	$string = shift;
	$string =~ s/^\s+//;
	return $string;
}

sub rtrim($)
{
	$string = shift;
	$string =~ s/\s+$//;
	return $string;
}