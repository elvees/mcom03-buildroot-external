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

MCOM03_SBL_DDRINIT_PLAT = \
	$(word 1, $(strip $(foreach i, $(call qstrip,$(BR2_PACKAGE_DDRINIT_DEFCONFIGS)), \
		$(if $(findstring bootrom,$i),,$i))))

MCOM03_SBL_CONF_OPTS += -DDDRINIT_PATH=$(BINARIES_DIR)/ddrinit-$(subst :,-,$(MCOM03_SBL_DDRINIT_PLAT))/ddrinit.bin
MCOM03_SBL_CONF_OPTS += -DTFA_PATH=$(BINARIES_DIR)/bl31.bin
ifneq ($(wildcard $(BINARIES_DIR)/bl32.bin),)
MCOM03_SBL_CONF_OPTS += -DBL32_PATH=$(BINARIES_DIR)/bl32.bin
endif
MCOM03_SBL_CONF_OPTS += -DUBOOT_PATH=$(BINARIES_DIR)/u-boot.bin
MCOM03_SBL_CONF_OPTS += -DCMAKE_TOOLCHAIN_FILE=$(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_CMAKE_FILE)
MCOM03_SBL_CONF_OPTS += -DCMAKE_INSTALL_PREFIX=

$(eval $(cmake-package))
