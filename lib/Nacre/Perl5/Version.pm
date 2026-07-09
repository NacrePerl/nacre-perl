package Nacre::Perl5::Version;
# ABSTRACT: Represents a version of Perl

use v5.36;
use Moo;
use MooX::ShortHas;
use Types::Common qw(InstanceOf StrMatch);
use version 0.77 ();

use constant VERSION_TAG_RE => qr{
	\A
	(?: perl- | v) # prefix
	(?<version> 5 \. \d+ \. \d+ )     # version
	\z
}x;

ro repo => (
	isa => InstanceOf['Nacre::Perl5::Repo'],
);

ro tag => (
	isa => StrMatch[VERSION_TAG_RE],
);

lazy version => sub ($self) {
	my $re = VERSION_TAG_RE;
	$self->tag =~ /$re/;
	return version->parse($1);
};

1;
