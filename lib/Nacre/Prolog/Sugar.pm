package Nacre::Prolog::Sugar;
# ABSTRACT: Prolog-safe sugar

use v5.36;
use Exporter 'import';
our @EXPORT_OK = qw(A AL);
use Language::Prolog::Types qw(prolog_list);
use Language::Prolog::Types::overload;

{
	package # hide from PAUSE
		Nacre::Prolog::Sugar::Atom;
	use overload '""' => sub {
		my $v = ${ shift() };
		if( $v !~ /
			(?:
				# must start with lowercase alpha
				^ [a-z]
				[A-Za-z0-9_]*
				$
			)
			|
			(?:
				# or be a number
				^
				[-+]? [0-9]+
				$
			)
			/x ) {
			my $qv = $v;
			$qv =~ s{\\}{\\\\}g;
			$qv =~ s{'}{\\'}g;
			$qv = "'$qv'";
			return $qv;
		}
		$v;
	};
	sub new { my ($class,$s) = @_; bless \$s }
}

sub A($s) { Nacre::Prolog::Sugar::Atom->new($s) }
sub AL(@x) { prolog_list(map A($_), @x) }

1;
