################################################################################
#
# mcom03-sbl
#
################################################################################

MCOM03_SBL_VERSION = master
MCOM03_SBL_SITE = ssh://gerrit.elvees.com:29418/mcom03/sbl
MCOM03_SBL_SITE_METHOD = git
MCOM03_SBL_LICENSE = GPLv2
MCOM03_SBL_DEPENDENCIES = host-mips-img-elf-toolchain \
	arm-trusted-firmware ddrinit uboot
MCOM03_SBL_INSTALL_TARGET_OPTS = DESTDIR=$(BINARIES_DIR) install/fast

MCOM03_SBL_CONF_OPTS += -DDDRINIT_PATH=$(BINARIES_DIR)/ddrinit-$(word 1, $(subst $\",,$(BR2_PACKAGE_DDRINIT_DEFCONFIGS)))/ddrinit.bin
MCOM03_SBL_CONF_OPTS += -DTFA_PATH=$(BINARIES_DIR)/bl31.bin
MCOM03_SBL_CONF_OPTS += -DUBOOT_PATH=$(BINARIES_DIR)/u-boot.bin
MCOM03_SBL_CONF_OPTS += -DCMAKE_TOOLCHAIN_FILE=$(HOST_DIR)/mips-img-elf/2018.09-03/share/cmake/toolchain.cmake
MCOM03_SBL_CONF_OPTS += -DCMAKE_INSTALL_PREFIX=

$(eval $(cmake-package))
