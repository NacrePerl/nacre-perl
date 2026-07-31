:- multifile(logtalk_library_path/2).
:- dynamic(logtalk_library_path/2).

:- logtalk_load_context(directory, Dir),
	assertz(logtalk_library_path(nacre_perl, Dir)).
