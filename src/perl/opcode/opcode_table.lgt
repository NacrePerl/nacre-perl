:- category(opcode_table).

	:- info([
		version is 1:0:0,
		comment is 'Common behaviour over a Perl release opcode table.'
	]).

	:- public(opcode/6).
	:- mode(opcode(?atom, ?integer, ?atom, ?atom, ?list, ?list), zero_or_more).
	:- info(opcode/6, [
		argnames is [ 'Name', 'Number', 'Desc', 'Check', 'Flags', 'Args' ]
	]).

	:- public(has_opcode/1).
	has_opcode(Name) :-
		::opcode(Name, _, _, _, _, _).

	:- public(added_since/2).
	:- mode(added_since(?object, ?atom), zero_or_more).
	:- info(added_since/2, [
		comment is 'True when `Name` is an opcode this release has that the older release `Older` does not. Requires the `versioned` category.',
		argnames is [ 'Older', 'Name' ]
	]).
	added_since(Older, Name) :-
		::older(Older),
		imports_category(Older, opcode_table),
		::opcode(Name, _, _, _, _, _),
		\+ Older::has_opcode(Name).

:- end_category.
