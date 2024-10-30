################################################################################
#
# mcom03-linux-utils
#
################################################################################

MCOM03_LINUX_UTILS_VERSION = master
MCOM03_LINUX_UTILS_SITE = ssh://gerrit.elvees.com:29418/mcom03/linux-utils
MCOM03_LINUX_UTILS_SITE_METHOD = git
MCOM03_LINUX_UTILS_LICENSE = Proprietary
MCOM03_LINUX_UTILS_DEPENDENCIES = mpv

ifeq ($(BR2_PACKAGE_MCOM03_LINUX_UTILS_SET_HOSTNAME_SERVICE),y)
MCOM03_LINUX_UTILS_CONF_OPTS += -DSET_HOSTNAME=ON
endif

ifeq ($(BR2_PACKAGE_MCOM03_LINUX_UTILS_WESTON),y)
MCOM03_LINUX_UTILS_CONF_OPTS += -DWESTON=ON
endif

$(eval $(cmake-package))
