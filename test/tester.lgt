:- initialization((
	set_logtalk_flag(report, warnings),
	logtalk_load(lgtunit(loader)),
	% Global flag, as the nested loaders pass their own options and would
	% otherwise drop `debug(on)`.
	set_logtalk_flag(debug, on),
	logtalk_load('../loader', [source_data(on)]),
	set_logtalk_flag(debug, off),
	logtalk_load(test, [hook(lgtunit)]),
	test::run
)).
