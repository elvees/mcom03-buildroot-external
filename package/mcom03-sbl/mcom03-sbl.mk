################################################################################
#
# mcom03-sbl
#
################################################################################

MCOM03_SBL_VERSION = master
MCOM03_SBL_SITE = ssh://gerrit.elvees.com:29418/mcom03/sbl
MCOM03_SBL_SITE_METHOD = git
MCOM03_SBL_LICENSE = GPLv2
MCOM03_SBL_DEPENDENCIES = host-toolchain-mipsel-elvees-elf32 \
	arm-trusted-firmware ddrinit uboot
MCOM03_SBL_INSTALL_TARGET_OPTS = DESTDIR=$(BINARIES_DIR)/sbl install/fast

MCOM03_SBL_CONF_OPTS += -DIMAGES_PATH=$(BINARIES_DIR)
MCOM03_SBL_CONF_OPTS += -DCMAKE_TOOLCHAIN_FILE=$(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_CMAKE_FILE)
MCOM03_SBL_CONF_OPTS += -DCMAKE_INSTALL_PREFIX=

MCOM03_SBL_CONF_OPTS += -DDDRINIT_DTB_MAP_FILE="$(shell readlink -f $(BR2_MCOM03_DDRINIT_DTB_MAP))"

ifneq ($(MCOM03_SBL_OVERRIDE_SRCDIR),)
MCOM03_SBL_CONF_OPTS += -DGIT_DIR=$(MCOM03_SBL_OVERRIDE_SRCDIR)
else
MCOM03_SBL_CONF_OPTS += -DGIT_DIR=$(MCOM03_SBL_DL_DIR)/git
endif

$(eval $(cmake-package))
