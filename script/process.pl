#!/usr/bin/env perl
# PODNAME: process.pl
# ABSTRACT: Process the opcodes

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Nacre::Perl5::Repo;
use List::UtilsBy qw(partition_by sort_by);

sub main {
	my $repo = Nacre::Perl5::Repo->new(
		gitdir => 'vendor/Perl/perl5/.git'
	);

	my @versions = $repo->perl5_versions->@*;
	my %partitions = partition_by { ($_->version->normal =~ /(v\d+\.\d+)/)[0] } @versions;
	my @versions_filtered =
		sort_by { $_->version }
		map {
			my $p = $_;
			my @sorted = sort_by { $_->version } @$p;
			$sorted[-1];
		}
		values %partitions;
}

main;
