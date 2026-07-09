package Nacre::Perl5::Opcode::Table;
# ABSTRACT: Parse the perl5 opcode table

use v5.36;
use Moo;
use MooX::ShortHas;
use Types::Common qw(Str);

ro table => (
	isa => Str,
);

1;
