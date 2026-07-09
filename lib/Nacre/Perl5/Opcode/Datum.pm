package Nacre::Perl5::Opcode::Datum;
# ABSTRACT: A single opcode

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

1;
