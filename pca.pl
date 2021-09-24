#!/usr/bin/perl
# Run PCA 
use strict; use warnings;
use File::Temp;

# Initiate
my ($in, $r2) = @ARGV; 
$r2 //= 0.2;
my %path = (
	plink => '/home/gennady/tools/plink_5.2/plink' 
);

# Check input
die "$in.bed doesn't exist" unless -e "$in.bed";

# Show input
print "File: $in\nr2: $r2\n";

# Prune the SNPs by r2 
my $fh = File::Temp->new();
my $tmp = $fh->filename; 
my $cmd = "$path{plink} \\
	--bfile $in \\
	--indep-pairwise 50 10 $r2 \\
	--allow-no-sex \\
	--out $tmp";
system($cmd) == 0 or die "Pruning failed...:$!";

# Run PCA
my $out = "$in.pruned";
$cmd = "$path{plink} \\
	--bfile $in \\
	--extract $tmp.prune.in \\
	--pca \\
	--allow-no-sex \\
	--make-bed --out $out";
system($cmd) == 0 or die "Failed PCA with Plink: $!";

# Clean
unlink glob "$tmp*";
