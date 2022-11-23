################################################################################
#
# mcom03-sbl-tl
#
################################################################################

MCOM03_SBL_TL_IMAGE = image/sbl-tl.bin

MCOM03_SBL_TL_INSTALL_TARGET = NO
MCOM03_SBL_TL_INSTALL_IMAGES = YES

MCOM03_SBL_TL_DEPENDENCIES = host-toolchain-mipsel-elvees-elf32

# Installation from source code
ifeq ($(BR2_PACKAGE_MCOM03_SBL_TL_INSTALL_SRC),y)
MCOM03_SBL_TL_VERSION = $(call qstrip,$(BR2_PACKAGE_MCOM03_SBL_TL_REPO_VERSION))
MCOM03_SBL_TL_SITE = git@git.elvees.com:TrustLab-Engineers-Internal/sbl-tl.git
MCOM03_SBL_TL_SITE_METHOD = git
MCOM03_SBL_TL_GIT_SUBMODULES = YES

MCOM03_SBL_TL_MAKE_OPTS += \
	CROSS_COMPILE=$(BR2_PACKAGE_MCOM03_SBL_TL_TOOLCHAIN) \
	$(call qstrip,$(BR2_PACKAGE_MCOM03_SBL_TL_ADDITIONAL_VARIABLES))

define MCOM03_SBL_TL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean; \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MCOM03_SBL_TL_MAKE_OPTS);
endef

ifneq ($(MCOM03_SBL_TL_OVERRIDE_SRCDIR),)
MCOM03_SBL_TL_GIT_DIR = $(MCOM03_SBL_TL_OVERRIDE_SRCDIR)
else
MCOM03_SBL_TL_GIT_DIR = $(MCOM03_SBL_TL_DL_DIR)/git
endif

MCOM03_SBL_TL_TARBALL_VERSION = $(shell git -C $(MCOM03_SBL_TL_GIT_DIR) describe --always || echo "unknown")-$(shell date +%Y%m%d)

define MCOM03_SBL_TL_INSTALL_IMAGES_CMDS
	cp -f $(@D)/$(MCOM03_SBL_TL_IMAGE) $(BINARIES_DIR)
	tar -C $(@D) -czf \
		$(BINARIES_DIR)/mcom03-sbl-tl-$(MCOM03_SBL_TL_TARBALL_VERSION).tar.gz \
		$(MCOM03_SBL_TL_IMAGE)
endef

# Installation from tarball with binaries
else
MCOM03_SBL_TL_VERSION = latest
MCOM03_SBL_TL_SITE = http://dist.elvees.com/mcom03/packages/mcom03-sbl-tl
MCOM03_SBL_TL_STRIP_COMPONENTS = 0

define MCOM03_SBL_TL_INSTALL_IMAGES_CMDS
	cp -f $(@D)/$(MCOM03_SBL_TL_IMAGE) $(BINARIES_DIR)
endef

endif

$(eval $(generic-package))
