package Nacre::Perl5::Repo;
# ABSTRACT: Represents the git repo for perl5

use v5.36;
use Moo;
use MooX::ShortHas;
use Types::Path::Tiny qw(Dir);

use Git::Wrapper;
use Nacre::Perl5::Version;

ro gitdir => (
	isa => Dir,
	coerce => 1,
);

lazy _git_wrapper => sub ($self) {
	Git::Wrapper->new( $self->gitdir );
};

lazy perl5_tags => sub ($self) {
	my $re = Nacre::Perl5::Version::VERSION_TAG_RE();
	[ grep { /$re/ } $self->_git_wrapper->tag( '-l' ) ];
};

lazy perl5_versions => sub ($self) {
	[ map {
		Nacre::Perl5::Version->new( repo => $self, tag => $_ )
	} $self->perl5_tags->@* ];
};

1;
