################################################################################
#
# mcom03-tl-core
#
################################################################################

MCOM03_TL_CORE_IMAGE = image/tl-core.bin

MCOM03_TL_CORE_INSTALL_TARGET = NO
MCOM03_TL_CORE_INSTALL_IMAGES = YES

MCOM03_TL_CORE_DEPENDENCIES = host-toolchain-mipsel-elvees-elf32

# Force build from sources if override srcdir is enabled
ifneq ($(MCOM03_TL_CORE_OVERRIDE_SRCDIR),)
MCOM03_TL_CORE_INSTALL_SRC = y
MCOM03_TL_CORE_GIT_DIR = $(MCOM03_TL_CORE_OVERRIDE_SRCDIR)
else
MCOM03_TL_CORE_INSTALL_SRC = $(BR2_PACKAGE_MCOM03_TL_CORE_INSTALL_SRC)
MCOM03_TL_CORE_GIT_DIR = $(MCOM03_TL_CORE_DL_DIR)/git
endif

# Installation from source code
ifeq ($(MCOM03_TL_CORE_INSTALL_SRC),y)
MCOM03_TL_CORE_VERSION = $(call qstrip,$(BR2_PACKAGE_MCOM03_TL_CORE_REPO_VERSION))
MCOM03_TL_CORE_SITE = ssh://gerrit.elvees.com:29418/mcom03/tl-core
MCOM03_TL_CORE_SITE_METHOD = git
MCOM03_TL_CORE_GIT_SUBMODULES = YES

MCOM03_TL_CORE_MAKE_OPTS += \
	CROSS_COMPILE=$(BR2_PACKAGE_MCOM03_TL_CORE_TOOLCHAIN) \
	$(call qstrip,$(BR2_PACKAGE_MCOM03_TL_CORE_ADDITIONAL_VARIABLES))

define MCOM03_TL_CORE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean; \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MCOM03_TL_CORE_MAKE_OPTS);
endef

MCOM03_TL_CORE_TARBALL_VERSION = $(shell git -C $(MCOM03_TL_CORE_GIT_DIR) describe --always || echo "unknown")-$(shell date +%Y%m%d)

define MCOM03_TL_CORE_INSTALL_IMAGES_CMDS
	cp -f $(@D)/$(MCOM03_TL_CORE_IMAGE) $(BINARIES_DIR)
	tar -C $(@D) -czf \
		$(BINARIES_DIR)/mcom03-tl-core-$(MCOM03_TL_CORE_TARBALL_VERSION).tar.gz \
		$(MCOM03_TL_CORE_IMAGE)
endef

# Installation from tarball with binaries
else
MCOM03_TL_CORE_VERSION = latest
MCOM03_TL_CORE_SITE = $(BR2_ELVEES_BINARY_PACKAGES_SITE)/mcom03-tl-core
MCOM03_TL_CORE_STRIP_COMPONENTS = 0

define MCOM03_TL_CORE_INSTALL_IMAGES_CMDS
	cp -f $(@D)/$(MCOM03_TL_CORE_IMAGE) $(BINARIES_DIR)
endef

endif

$(eval $(generic-package))
