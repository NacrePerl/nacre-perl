:- initialization((
	set_logtalk_flag(report, warnings),
	logtalk_load(lgtunit(loader)),
	logtalk_load('../loader', [source_data(on), debug(on)]),
	logtalk_load(test, [hook(lgtunit)]),
	test::run
)).
