#!/usr/bin/env perl
# PODNAME: process.pl
# ABSTRACT: Process the opcodes

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Nacre::App;

sub main {
	my $app = Nacre::App->new_with_options;
	$app->run;
}

main;
