:- object(test,
	extends(lgtunit)).

	cover(perl_v5_38).
	cover(opcode_table).
	cover(versioned).

	test(perl_v5_38_knows_null, true) :-
		perl_v5_38::has_opcode(null).

	test(perl_v5_38_older_perl_v5_36, true) :-
		perl_v5_38::older(perl_v5_36).

	test(perl_v5_36_not_older_perl_v5_38, fail) :-
		perl_v5_36::older(perl_v5_38).

	% Minor version compares numerically, not lexically.
	test(perl_v5_10_older_perl_v5_6, true) :-
		perl_v5_10::older(perl_v5_6).

	test(perl_v5_38_not_older_than_itself, fail) :-
		perl_v5_38::older(perl_v5_38).

	test(perl_v5_42_added_since_perl_v5_6, true) :-
		once(perl_v5_42::added_since(perl_v5_6, _)).

	% A newer release is never an `Older` release.
	test(added_since_rejects_newer_release, fail) :-
		perl_v5_20::added_since(perl_v5_42, _).

:- end_object.
