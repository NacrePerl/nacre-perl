# make-dialect: GNU Make

include maint/common.mk
include maint/clone.mk

.PHONY: setup
setup: \
	clone-perl5 \
	clone-corpus-base \
	swi-prolog-pack-install \
	#

VENDOR_PERL5_GIT_DIR := vendor/Perl/perl5
.PHONY: clone-perl5
clone-perl5:
	$(call symlink_up_down,Perl/perl5) \
		|| $(call check_and_clone,https://github.com/Perl/perl5.git,$(VENDOR_PERL5_GIT_DIR))

.PHONY: clone-corpus-base
clone-corpus-base:
	$(call symlink_up_down,NacrePerl/corpus-base) \
		|| $(call check_and_clone,https://github.com/NacrePerl/corpus-base.git,vendor/NacrePerl/corpus-base)

SWIPL_PACK_LIST := \
		logtalk \
		#
.PHONY: swi-prolog-pack-install
swi-prolog-pack-install:
	swipl pack install $(SWIPL_PACK_LIST)


.PHONY: test
test: \
	test-logtalk-swipl \
	#

define test_logtalk_SWI_PROLOG
use_module(library(logtalk)),
	logtalk_load('test/tester'),
	halt
endef
export test_logtalk_SWI_PROLOG
.PHONY: test-logtalk-swipl
test-logtalk-swipl:
	swipl -g "$$test_logtalk_SWI_PROLOG"
