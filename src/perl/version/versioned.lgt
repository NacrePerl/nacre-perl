:- category(versioned).

	:- info([
		version is 1:0:0,
		comment is 'Common behaviour over an object representing a Perl release.'
	]).

	:- public(version/1).
	:- mode(version(?compound), zero_or_one).
	:- info(version/1, [
		comment is 'Version of the Perl release, as `Major:Minor`.',
		argnames is [ 'Version' ]
	]).

	:- public(older/1).
	:- mode(older(?object), zero_or_more).
	:- info(older/1, [
		comment is 'True when `Other` is a release older than this one.',
		argnames is [ 'Other' ]
	]).
	older(Other) :-
		::version(Major:Minor),
		imports_category(Other, versioned),
		Other::version(OtherMajor:OtherMinor),
		(	OtherMajor < Major
		;	OtherMajor =:= Major,
			OtherMinor < Minor
		).

:- end_category.
