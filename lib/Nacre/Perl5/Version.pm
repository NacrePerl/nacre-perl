package Nacre::Perl5::Version;
# ABSTRACT: Represents a version of Perl

use v5.36;
use Moo;
use MooX::ShortHas;
use Types::Common qw(InstanceOf StrMatch);
use version 0.77 ();

use Nacre::Perl5::Opcode::Table;

use namespace::clean;

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

lazy version_two_digit => sub ($self) {
	($self->version->normal =~ /^(v\d+\.\d+)/)[0];
};

lazy opcode_table => sub ($self) {
	my $content;
	my $wrapper = $self->repo->_git_wrapper;

	my $file_tag_content = sub ($tag, $file) {
		join "\n", $wrapper->show( "$tag:$file" );
	};

	my $extract_table_from_END = sub ($script) {
		( $script =~ m{^__END__$ \n (.*)}xms )[0];
	};

	# NOTE: These are listed in reverse chronological order as the opcode
	# data was moved.
	if ( eval { $content = $file_tag_content->( $self->tag, 'regen/opcodes' ) ; 1 } ) {
		Nacre::Perl5::Opcode::Table->new(
			table => $content
		);
	} elsif ( eval { $content = $file_tag_content->($self->tag, 'regen/opcode.pl'); 1 } ) {
		Nacre::Perl5::Opcode::Table->new(
			table => $extract_table_from_END->($content)
		);
	} elsif ( eval { $content = $file_tag_content->( $self->tag, 'opcode.pl'); 1 } ) {
		Nacre::Perl5::Opcode::Table->new(
			table => $extract_table_from_END->($content)
		);
	} else {
		die "perl5 tag @{[ $self->tag ]}: Unknown opcode table location";
	}
};

1;
