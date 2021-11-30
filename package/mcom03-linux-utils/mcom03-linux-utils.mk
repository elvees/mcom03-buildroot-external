################################################################################
#
# mcom03-linux-utils
#
################################################################################

MCOM03_LINUX_UTILS_VERSION = master
MCOM03_LINUX_UTILS_SITE = ssh://gerrit.elvees.com:29418/mcom03/linux-utils.git
MCOM03_LINUX_UTILS_SITE_METHOD = git
MCOM03_LINUX_UTILS_LICENSE = Proprietary
MCOM03_LINUX_UTILS_DEPENDENCIES = mpv

$(eval $(cmake-package))
