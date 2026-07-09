package Nacre::Perl5::Repo;
# ABSTRACT: Represents the git repo for perl5

use v5.36;
use Moo;
use MooX::ShortHas;
use Types::Path::Tiny qw(Dir);

use Git::Wrapper;

ro gitdir => (
	isa => Dir,
	coerce => 1,
);

lazy _git_wrapper => sub ($self) {
	Git::Wrapper->new( $self->gitdir );
};

lazy perl5_tags => sub ($self) {
	[ grep {
		/^(?:perl-5\.|^v5\.)/
	} $self->_git_wrapper->tag( '-l' ) ];
};

1;
