:- multifile(logtalk_library_path/2).
:- dynamic(logtalk_library_path/2).

:- logtalk_load_context(directory, Dir),
	assertz(logtalk_library_path(nacre_perl, Dir)).

logtalk_library_path(nacre_perl_src         , nacre_perl('src/')).
logtalk_library_path(nacre_perl_generated   , nacre_perl('GENERATED/')).
logtalk_library_path(nacre_perl_generated_op, nacre_perl_generated('src/perl/opcode/')).
