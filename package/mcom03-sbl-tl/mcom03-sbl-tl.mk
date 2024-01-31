################################################################################
#
# mcom03-sbl-tl
#
################################################################################

MCOM03_SBL_TL_IMAGE = image/sbl-tl.bin

MCOM03_SBL_TL_INSTALL_TARGET = NO
MCOM03_SBL_TL_INSTALL_IMAGES = YES

MCOM03_SBL_TL_DEPENDENCIES = host-toolchain-mipsel-elvees-elf32

# Force build from sources if override srcdir is enabled
ifneq ($(MCOM03_SBL_TL_OVERRIDE_SRCDIR),)
MCOM03_SBL_TL_INSTALL_SRC = y
MCOM03_SBL_TL_GIT_DIR = $(MCOM03_SBL_TL_OVERRIDE_SRCDIR)
else
MCOM03_SBL_TL_INSTALL_SRC = $(BR2_PACKAGE_MCOM03_SBL_TL_INSTALL_SRC)
MCOM03_SBL_TL_GIT_DIR = $(MCOM03_SBL_TL_DL_DIR)/git
endif

# Installation from source code
ifeq ($(MCOM03_SBL_TL_INSTALL_SRC),y)
MCOM03_SBL_TL_VERSION = $(call qstrip,$(BR2_PACKAGE_MCOM03_SBL_TL_REPO_VERSION))
MCOM03_SBL_TL_SITE = ssh://gerrit.elvees.com:29418/mcom03/sbl-tl
MCOM03_SBL_TL_SITE_METHOD = git
MCOM03_SBL_TL_GIT_SUBMODULES = YES

MCOM03_SBL_TL_MAKE_OPTS += \
	CROSS_COMPILE=$(BR2_PACKAGE_MCOM03_SBL_TL_TOOLCHAIN) \
	GIT_DIR=$(MCOM03_SBL_TL_GIT_DIR) \
	$(call qstrip,$(BR2_PACKAGE_MCOM03_SBL_TL_ADDITIONAL_VARIABLES))

define MCOM03_SBL_TL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MCOM03_SBL_TL_MAKE_OPTS) clean; \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MCOM03_SBL_TL_MAKE_OPTS);
endef

define MCOM03_SBL_TL_INSTALL_IMAGES_CMDS
	cp -f $(@D)/$(MCOM03_SBL_TL_IMAGE) $(BINARIES_DIR)
	tar -C $(@D) -czf \
		$(BINARIES_DIR)/$(call TARBALL_NAME,MCOM03_SBL_TL).gz \
		$(MCOM03_SBL_TL_IMAGE)
endef

# Installation from tarball with binaries
else
MCOM03_SBL_TL_VERSION = latest
MCOM03_SBL_TL_SITE = $(BR2_ELVEES_BINARY_PACKAGES_SITE)/mcom03-sbl-tl
MCOM03_SBL_TL_STRIP_COMPONENTS = 0

define MCOM03_SBL_TL_INSTALL_IMAGES_CMDS
	cp -f $(@D)/$(MCOM03_SBL_TL_IMAGE) $(BINARIES_DIR)
endef

endif

$(eval $(generic-package))
