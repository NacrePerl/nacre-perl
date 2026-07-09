package Nacre::App;
# ABSTRACT: CLI app

use v5.36;
use Moo;
use CLI::Osprey;
use MooX::ShortHas;

use Nacre::Perl5::Repo;
use List::UtilsBy qw(partition_by sort_by);

use namespace::clean;

lazy repo => sub ($self) {
	Nacre::Perl5::Repo->new(
		gitdir => 'vendor/Perl/perl5/.git'
	);
};

lazy versions => sub ($self) {
	$self->repo->perl5_versions;
};

lazy versions_filtered => sub ($self) {
	my %partitions = partition_by { ($_->version->normal =~ /(v\d+\.\d+)/)[0] }
		$self->versions->@*;
	my @versions_filtered =
		grep { ($_->version->normal =~ /v\d+\.(\d+)/)[0] % 2 == 0 }
		sort_by { $_->version }
		map {
			my $p = $_;
			my @sorted = sort_by { $_->version } @$p;
			$sorted[-1];
		}
		values %partitions;
	\@versions_filtered;
};

sub run ($self) {
	for my $v ($self->versions_filtered->@*) {
		$v->opcode_table;
	}
}

1;
