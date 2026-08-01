package Nacre::App;
# ABSTRACT: CLI app

use v5.36;
use namespace::autoclean;
use FindBin;
use Moo;
use CLI::Osprey;
use MooX::ShortHas;

use Nacre::Perl5::Repo;
use Path::Tiny qw(path);
use List::UtilsBy qw(partition_by sort_by);

lazy project_root => sub {
	path($FindBin::Bin, '..');
};

option perl5_git_path => (
	is      => 'ro',
	format  => 's',
	default => sub ($self) {
		$self->project_root->child('vendor/Perl/perl5/.git')
	},
);

lazy repo => sub ($self) {
	die <<~'EOF' unless -d $self->perl5_git_path;
	Missing `perl5` checkout. Run:

	    make clone-perl5
	EOF

	Nacre::Perl5::Repo->new(
		gitdir => $self->perl5_git_path,
	);
};

lazy versions => sub ($self) {
	$self->repo->perl5_versions;
};

lazy versions_filtered => sub ($self) {
	my %partitions = partition_by { $_->version_two_digit }
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
	...
}

subcommand generate => 'Nacre::App::Generate';

1;
