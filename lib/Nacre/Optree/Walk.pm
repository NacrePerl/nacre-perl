package Nacre::Optree::Walk;
# ABSTRACT: Walk the B optree of a compiled file and emit Prolog terms

use v5.36;

use B qw(
	class ppname main_start main_root main_cv cstring svref_2object
	SVf_IOK SVf_NOK SVf_POK SVf_IVisUV SVf_FAKE OPf_KIDS OPf_SPECIAL
	OPf_STACKED
	OPpSPLIT_ASSIGN OPpSPLIT_LEX
	CVf_ANON CVf_LEXICAL CVf_NAMED
	PAD_FAKELEX_ANON PAD_FAKELEX_MULTI SVf_ROK
);

use Language::Prolog::Sugar functors => [qw(op)];
use Language::Prolog::Sugar functors => { pair => '-' };
use Language::Prolog::Types qw(prolog_atom prolog_list prolog_string);

=head2 op_to_term

Turn one L<B::OP> (and, recursively, its kids) into

    op(OpName, [Kid, ...], [...])

where Name is an atom. Kids are the ops chained under an op that carries the
C<OPf_KIDS> flag, walked first-then-sibling until the null op.

=cut
sub op_to_term ($op) {
	my @kids;

	if ($op->flags & OPf_KIDS) {
		for (my $kid = $op->first; $$kid; $kid = $kid->sibling) {
			push @kids, op_to_term($kid);
		}
	}

	my @extra;
	if($op->name eq 'const') {
		my $sv = $op->sv;
		if($sv->FLAGS & SVf_POK) {
			# NOTE Language::Prolog::Types::overload doesn't
			# quote Prolog atoms properly on this end, but should
			# be fine over the C interface.
			push @extra, pair(svval => prolog_atom("'@{[ $sv->PV ]}'"));
		}
	}

	return op(
		prolog_atom($op->name),
		prolog_list(@kids),
		prolog_list(@extra),
	);
}

=head2 walk_root

Walk from a root op (the main program's root by default).
Returns C<undef> for an empty program (a C<NULL> root).

=cut
sub walk_root ($root = main_root()) {
	return if class($root) eq 'NULL';
	return op_to_term($root);
}

=head1 DESCRIPTION

Build the terms with the L<Language::Prolog::Sugar> constructors.

  op(+OpName, +KidsList, +ExtraPairList)

C<op/3> is our functor for a single node; the op name becomes an atom C<OpName>
and the kids become a proper Prolog list C<KidsList>.

L<CHECK|perlfunc/CHECK> is the earliest phase at which the whole file has finished
compiling and its optree is reachable via L<B::main_root>.  Loading this
module registers the block, so

    perl -MNacre::Optree::Walk file.pl

prints the terms for C<file.pl>.

=cut
CHECK {
	my $term = walk_root();
	do {#DEBUG
		use Language::Prolog::Types::overload;
		say "${term}." if defined $term;
	} if 1;#DEBUG
}

1;
