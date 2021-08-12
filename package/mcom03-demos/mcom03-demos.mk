################################################################################
#
# mcom03-demos
#
################################################################################

MCOM03_DEMOS_VERSION = master
MCOM03_DEMOS_SITE = ssh://gerrit.elvees.com:29418/mcom03/demos.git
MCOM03_DEMOS_SITE_METHOD = git
MCOM03_DEMOS_LICENSE = Proprietary
MCOM03_DEMOS_DEPENDENCIES = mpv

$(eval $(cmake-package))
