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
MCOM03_SBL_INSTALL_TARGET_OPTS = DESTDIR=$(BINARIES_DIR) install/fast

MCOM03_SBL_CONF_OPTS += -DIMAGES_PATH=$(BINARIES_DIR)
MCOM03_SBL_CONF_OPTS += -DCMAKE_TOOLCHAIN_FILE=$(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_CMAKE_FILE)
MCOM03_SBL_CONF_OPTS += -DCMAKE_INSTALL_PREFIX=

MCOM03_SBL_CONF_OPTS += -DDDRINIT_DTB_MAP_FILE="$(shell readlink -f $(BR2_MCOM03_DDRINIT_DTB_MAP))"

ifneq ($(MCOM03_SBL_OVERRIDE_SRCDIR),)
MCOM03_SBL_CONF_OPTS += -DGIT_DIR=$(MCOM03_SBL_OVERRIDE_SRCDIR)
else
MCOM03_SBL_CONF_OPTS += -DGIT_DIR=$(MCOM03_SBL_DL_DIR)/git
endif

ifneq ($(BR2_PACKAGE_MCOM03_SBL_RECOVERY_ENABLE),)
MCOM03_SBL_CONF_OPTS += -DRECOVERY_ENABLE=ON
endif

ifneq ($(BR2_PACKAGE_MCOM03_SBL_ADDITIONAL_VARIABLES),)
MCOM03_SBL_CONF_OPTS += $(call qstrip,$(BR2_PACKAGE_MCOM03_SBL_ADDITIONAL_VARIABLES))
endif

$(eval $(cmake-package))
