# make-dialect: GNU Make

VENDOR_PERL5_GIT_DIR := vendor/Perl/perl5
export VENDOR_PERL5_GIT_DIR

.PHONY: clone-perl5
clone-perl5:
	{ [ -d $$VENDOR_PERL5_GIT_DIR ] \
		&& [ `git -C $$VENDOR_PERL5_GIT_DIR rev-parse --is-inside-work-tree` = "true" ] ; } \
		|| git clone https://github.com/Perl/perl5.git $$VENDOR_PERL5_GIT_DIR
