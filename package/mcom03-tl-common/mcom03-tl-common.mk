################################################################################
#
# mcom03-tl-common
#
################################################################################

MCOM03_TL_COMMON_IMAGE = image/tl-common.bin

MCOM03_TL_COMMON_INSTALL_TARGET = NO
MCOM03_TL_COMMON_INSTALL_IMAGES = YES

MCOM03_TL_COMMON_DEPENDENCIES = host-toolchain-mipsel-elvees-elf32

# Installation from source code
ifeq ($(BR2_PACKAGE_MCOM03_TL_COMMON_INSTALL_SRC),y)
MCOM03_TL_COMMON_VERSION = $(call qstrip,$(BR2_PACKAGE_MCOM03_TL_COMMON_REPO_VERSION))
MCOM03_TL_COMMON_SITE = ssh://git@git.elvees.com/TrustLab-Engineers-Internal/tl-common.git
MCOM03_TL_COMMON_SITE_METHOD = git
MCOM03_TL_COMMON_GIT_SUBMODULES = YES

MCOM03_TL_COMMON_MAKE_OPTS += \
	CROSS_COMPILE=$(BR2_PACKAGE_MCOM03_TL_COMMON_TOOLCHAIN) \
	$(call qstrip,$(BR2_PACKAGE_MCOM03_TL_COMMON_ADDITIONAL_VARIABLES))

define MCOM03_TL_COMMON_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean; \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MCOM03_TL_COMMON_MAKE_OPTS);
endef

ifneq ($(MCOM03_TL_COMMON_OVERRIDE_SRCDIR),)
MCOM03_TL_COMMON_GIT_DIR = $(MCOM03_TL_COMMON_OVERRIDE_SRCDIR)
else
MCOM03_TL_COMMON_GIT_DIR = $(MCOM03_TL_COMMON_DL_DIR)/git
endif

MCOM03_TL_COMMON_TARBALL_VERSION = $(shell git -C $(MCOM03_TL_COMMON_GIT_DIR) describe --always || echo "unknown")-$(shell date +%Y%m%d)

define MCOM03_TL_COMMON_INSTALL_IMAGES_CMDS
	cp -f $(@D)/$(MCOM03_TL_COMMON_IMAGE) $(BINARIES_DIR)
	tar -C $(@D) -czf \
		$(BINARIES_DIR)/mcom03-tl-common-$(MCOM03_TL_COMMON_TARBALL_VERSION).tar.gz \
		$(MCOM03_TL_COMMON_IMAGE)
endef

# Installation from tarball with binaries
else
MCOM03_TL_COMMON_VERSION = latest
MCOM03_TL_COMMON_SITE = http://dist.elvees.com/mcom03/packages/mcom03-tl-common
MCOM03_TL_COMMON_STRIP_COMPONENTS = 0

define MCOM03_TL_COMMON_INSTALL_IMAGES_CMDS
	cp -f $(@D)/$(MCOM03_TL_COMMON_IMAGE) $(BINARIES_DIR)
endef

endif

$(eval $(generic-package))
