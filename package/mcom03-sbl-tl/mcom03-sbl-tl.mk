################################################################################
#
# mcom03-sbl-tl
#
################################################################################

MCOM03_SBL_TL_VERSION = $(call qstrip,$(BR2_PACKAGE_MCOM03_SBL_TL_REPO_VERSION))
MCOM03_SBL_TL_SITE = git@git.elvees.com:TrustLab-Engineers-Internal/sbl-tl.git
MCOM03_SBL_TL_SITE_METHOD = git
MCOM03_SBL_TL_GIT_SUBMODULES = YES
MCOM03_SBL_TL_DEPENDENCIES = host-toolchain-mipsel-elvees-elf32

MCOM03_SBL_TL_INSTALL_TARGET = NO
MCOM03_SBL_TL_INSTALL_IMAGES = YES

MCOM03_SBL_TL_MAKE_OPTS += \
	CROSS_COMPILE=$(BR2_PACKAGE_MCOM03_SBL_TL_TOOLCHAIN) \
	$(call qstrip,$(BR2_PACKAGE_MCOM03_SBL_TL_ADDITIONAL_VARIABLES))

define MCOM03_SBL_TL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean; \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MCOM03_SBL_TL_MAKE_OPTS);
endef

define MCOM03_SBL_TL_INSTALL_IMAGES_CMDS
	cp -f $(@D)/image/sbl-tl.bin $(BINARIES_DIR)
endef

$(eval $(generic-package))
