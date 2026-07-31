package Nacre::Perl5::Opcode::Datum;
# ABSTRACT: A single opcode

use v5.36;
use Moo;
use Sub::HandlesVia;
use MooX::ShortHas;
use Types::Common qw(ArrayRef);

use namespace::clean;

ro _row => (
	isa => ArrayRef,
	handles_via => 'Array',
	handles => {
		do {
			my @cols = qw(
				name
				description
				check_fnc
				flags
				operand_descr
			);
			map { $cols[$_] => [ get => $_ ] } 0..@cols-1;
		}
	}
);

lazy flags_list => sub ($self) {
	# split characters
	[ split '', $self->flags // '' ];
};

lazy operands_list => sub ($self) {
	# split on space
	[ split ' ', $self->operand_descr // '' ];
};

1;
