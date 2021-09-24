#!/usr/bin/perl
# A wrapper script to correct the strand and genomic coordimates of the markers
# The input file has three columns: 
# path/to/pref, where pref is prefix of *.{bed,bim,fam} 
# path/to/*.strand file
# path/to/output_pref

use strict; 
use warnings;

# Initiate
my $file = $ARGV[0];
my %path = (
	script => '/home/gennady/data/stroke/proc2/update_build.sh'
);


# Check input
help() unless defined $file;
die "$file doesn't exist" unless -e $file;

# Convert the data
open (my $fh, "<", $file) or die "Failed to open $file";
while (<$fh>) {
	chomp;
	my $cmd = "bash $path{script} $_";
	system("$cmd") == 0 or die "Failed to $cmd: $!";
}


# === subs ===
sub help {

	my $msg = <<"DOC";
	
	Usage: $0 <file>
		file: path/to/file.txt with three columns: 
			path/to/pref, where pref is prefix of *.{bed,bim,fam} 
			path/to/*.strand file
			path/to/output_pref

	Author: Gennady Khvorykh, info\@inzilico.com 
		
DOC
 
	print $msg;
	exit 0;

}

