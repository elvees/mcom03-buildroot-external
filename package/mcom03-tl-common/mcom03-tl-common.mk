################################################################################
#
# mcom03-tl-common
#
################################################################################

MCOM03_TL_COMMON_VERSION = $(call qstrip,$(BR2_PACKAGE_MCOM03_TL_COMMON_REPO_VERSION))
MCOM03_TL_COMMON_SITE = git@git.elvees.com:TrustLab-Engineers-Internal/tl-common.git
MCOM03_TL_COMMON_SITE_METHOD = git
MCOM03_TL_COMMON_GIT_SUBMODULES = YES
MCOM03_TL_COMMON_DEPENDENCIES = host-toolchain-mipsel-elvees-elf32

MCOM03_TL_COMMON_INSTALL_TARGET = NO
MCOM03_TL_COMMON_INSTALL_IMAGES = YES

MCOM03_TL_COMMON_MAKE_OPTS += \
	CROSS_COMPILE=$(BR2_PACKAGE_MCOM03_TL_COMMON_TOOLCHAIN) \
	$(call qstrip,$(BR2_PACKAGE_MCOM03_TL_COMMON_ADDITIONAL_VARIABLES))

define MCOM03_TL_COMMON_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean; \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MCOM03_TL_COMMON_MAKE_OPTS);
endef

define MCOM03_TL_COMMON_INSTALL_IMAGES_CMDS
	cp -f $(@D)/image/tl-common.bin $(BINARIES_DIR)
endef

$(eval $(generic-package))
