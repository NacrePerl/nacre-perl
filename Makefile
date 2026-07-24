# make-dialect: GNU Make

include maint/common.mk
include maint/clone.mk

.PHONY: setup
setup: \
	clone-perl5 \
	#

VENDOR_PERL5_GIT_DIR := vendor/Perl/perl5
.PHONY: clone-perl5
clone-perl5:
	$(call symlink_up_down,Perl/perl5) \
		|| $(call check_and_clone,https://github.com/Perl/perl5.git,$(VENDOR_PERL5_GIT_DIR))
