################################################################################
#
# acptest
#
################################################################################

ACPTEST_VERSION = master
ACPTEST_SITE = ssh://gerrit.elvees.com:29418/linux/modules/acptest
ACPTEST_SITE_METHOD = git
ACPTEST_LICENSE = GPL

$(eval $(kernel-module))
$(eval $(generic-package))
