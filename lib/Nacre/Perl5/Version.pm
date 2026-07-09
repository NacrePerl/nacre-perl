package Nacre::Perl5::Version;
# ABSTRACT: Represents a version of Perl

use v5.36;
use Moo;
use MooX::ShortHas;
use Types::Common qw(InstanceOf StrMatch);

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

1;
