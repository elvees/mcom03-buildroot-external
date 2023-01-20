################################################################################
#
# mcom03-hwinit
#
################################################################################

MCOM03_HWINIT_VERSION = $(call qstrip,$(BR2_PACKAGE_MCOM03_HWINIT_REPO_VERSION))
MCOM03_HWINIT_SITE = ssh://git@git.elvees.com/TrustLab-Engineers-Internal/hwinit.git
MCOM03_HWINIT_SITE_METHOD = git
MCOM03_HWINIT_GIT_SUBMODULES = YES
MCOM03_HWINIT_DEPENDENCIES = host-toolchain-mipsel-elvees-elf32

MCOM03_HWINIT_INSTALL_TARGET = NO
MCOM03_HWINIT_INSTALL_IMAGES = YES

MCOM03_HWINIT_MAKE_OPTS += \
	CROSS_COMPILE=$(BR2_PACKAGE_MCOM03_HWINIT_TOOLCHAIN) \
	$(call qstrip,$(BR2_PACKAGE_MCOM03_HWINIT_ADDITIONAL_VARIABLES))

define MCOM03_HWINIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean; \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MCOM03_HWINIT_MAKE_OPTS);
endef

define MCOM03_HWINIT_INSTALL_IMAGES_CMDS
	cp -f $(@D)/image/hwinit.bin $(BINARIES_DIR)
endef

$(eval $(generic-package))
