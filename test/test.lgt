:- object(test,
	extends(lgtunit)).

	cover(perl_v5_38).

	test(perl_v5_38_knows_null, true) :-
		perl_v5_38::has_opcode(null).

:- end_object.
