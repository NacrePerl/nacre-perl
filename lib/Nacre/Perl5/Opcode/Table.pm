package Nacre::Perl5::Opcode::Table;
# ABSTRACT: Parse the perl5 opcode table

use v5.36;
use Moo;
use MooX::ShortHas;
use Types::Common qw(Str);

use Nacre::Perl5::Opcode::Datum;

use namespace::clean;

ro table => (
	isa => Str,
);

sub opcodes ($self) {
	my $i = 0;
	[ map { Nacre::Perl5::Opcode::Datum->new(
			_row   => [ split /\t+/ ],
			number => $i++,
		) }
		grep { ! /^#|^\s*$/ }
		split /\n/, $self->table ];
}

1;
