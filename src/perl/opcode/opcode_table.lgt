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
	added_since(Older, Name) :-
		::opcode(Name, _, _, _, _, _),
		\+ Older::has_opcode(Name).

:- end_category.
