################################################################################
#
# mcom03-sbl
#
################################################################################

MCOM03_SBL_VERSION = master
MCOM03_SBL_SITE = ssh://gerrit.elvees.com:29418/mcom03/sbl
MCOM03_SBL_SITE_METHOD = git
MCOM03_SBL_LICENSE = GPLv2
MCOM03_SBL_DEPENDENCIES = arm-trusted-firmware ddrinit uboot
MCOM03_SBL_INSTALL_TARGET = NO
MCOM03_SBL_INSTALL_IMAGES = YES
define MCOM03_SBL_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/sbl-cpu.bin $(BINARIES_DIR)
endef

MCOM03_SBL_CONF_OPTS += -DDDRINIT_PATH=$(BINARIES_DIR)/ddrinit-mcom03bub/ddrinit.bin
MCOM03_SBL_CONF_OPTS += -DTFA_PATH=$(BINARIES_DIR)/bl31.bin
MCOM03_SBL_CONF_OPTS += -DUBOOT_PATH=$(BINARIES_DIR)/u-boot.bin

$(eval $(cmake-package))
