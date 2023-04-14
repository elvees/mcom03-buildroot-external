################################################################################
#
# mcom03-tl-sbimg
#
################################################################################

MCOM03_TL_SBIMG_VERSION = $(call qstrip,$(BR2_PACKAGE_MCOM03_TL_SBIMG_REPO_VERSION))
MCOM03_TL_SBIMG_SITE = ssh://gerrit.elvees.com:29418/mcom03/tl-sbimg
MCOM03_TL_SBIMG_SITE_METHOD = git

MCOM03_TL_SBIMG_DEPENDENCIES = host-bootrom-tools \
	ddrinit mcom03-sbl mcom03-sbl-tl mcom03-tl-core arm-trusted-firmware uboot

MCOM03_TL_SBIMG_INSTALL_TARGET = NO
MCOM03_TL_SBIMG_INSTALL_IMAGES = YES

MCOM03_TL_SBIMG_CERTS_URL = $(call qstrip,$(BR2_PACKAGE_MCOM03_TL_SBIMG_CERTS_URL))
MCOM03_TL_SBIMG_CERTS_TAR = $(MCOM03_TL_SBIMG_DL_DIR)/$(notdir $(MCOM03_TL_SBIMG_CERTS_URL))

MCOM03_TL_SBIMG_ROOT_CA = $(@D)/certs/rootCA.der
MCOM03_TL_SBIMG_NON_ROOT_CA = $(@D)/certs/nonRootCA.der
MCOM03_TL_SBIMG_FW_CA = $(@D)/certs/fwCA.der
MCOM03_TL_SBIMG_FW_PK = $(@D)/certs/fwPrivateKey.der

# Filter out ddrinit defconfigs without bootrom fragment
MCOM03_TL_SBIMG_DDRINIT_DEFCONFIGS = $(strip $(foreach i, \
	$(call qstrip,$(BR2_PACKAGE_DDRINIT_DEFCONFIGS)), \
		$(if $(findstring bootrom,$i),$i)))

MCOM03_TL_SBIMG_MAKE_OPTS += \
	MCOM03_TL_SBIMG_BOOTROM_TOOLS_INSTALL_DIR=$(HOST_BOOTROM_TOOLS_INSTALL_DIR) \
	MCOM03_TL_SBIMG_INSTALL_IMAGES_DIR=$(BINARIES_DIR) \
	MCOM03_TL_SBIMG_SEC_TYPE=$(BR2_PACKAGE_MCOM03_TL_SBIMG_SEC_TYPE) \
	MCOM03_TL_SBIMG_ENC_DSN=$(BR2_PACKAGE_MCOM03_TL_SBIMG_ENC_DSN) \
	MCOM03_TL_SBIMG_ENC_DUK=$(BR2_PACKAGE_MCOM03_TL_SBIMG_ENC_DUK) \
	MCOM03_TL_SBIMG_ENC_KEY=$(BR2_PACKAGE_MCOM03_TL_SBIMG_ENC_KEY) \
	MCOM03_TL_SBIMG_ROOT_CA=$(MCOM03_TL_SBIMG_ROOT_CA) \
	MCOM03_TL_SBIMG_NON_ROOT_CA=$(MCOM03_TL_SBIMG_NON_ROOT_CA) \
	MCOM03_TL_SBIMG_FW_CA=$(MCOM03_TL_SBIMG_FW_CA) \
	MCOM03_TL_SBIMG_FW_PK=$(MCOM03_TL_SBIMG_FW_PK) \
	MCOM03_TL_SBIMG_DDRINIT_DEFCONFIGS=$(MCOM03_TL_SBIMG_DDRINIT_DEFCONFIGS)

MCOM03_TL_SBIMG_EXTRA_DOWNLOADS = $(MCOM03_TL_SBIMG_CERTS_URL)

define MCOM03_TL_SBIMG_EXTRACT_CERTS
	mkdir -p $(@D)/certs
	$(TAR) xf $(MCOM03_TL_SBIMG_CERTS_TAR) -C $(@D)/certs
endef
MCOM03_TL_SBIMG_POST_EXTRACT_HOOKS += MCOM03_TL_SBIMG_EXTRACT_CERTS
MCOM03_TL_SBIMG_POST_RSYNC_HOOKS += MCOM03_TL_SBIMG_EXTRACT_CERTS

define MCOM03_TL_SBIMG_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MCOM03_TL_SBIMG_MAKE_OPTS)
endef

# The resulting bootrom sbimg image built with ddrinit defconfig
# <board>:bootrom:<fragment1> will have the following name
# <board>-bootrom-<fragment1>.sbimg. Only ddrinit defconfig with
# bootrom fragment will result in producing of sbimg images.
define MCOM03_TL_SBIMG_INSTALL_IMAGES_CMDS
	$(if $(MCOM03_TL_SBIMG_DDRINIT_DEFCONFIGS),
		for i in $(MCOM03_TL_SBIMG_DDRINIT_DEFCONFIGS); do \
			cp -f $(@D)/image/$${i//:/-}.sbimg $(BINARIES_DIR); \
		done

		cp -f $(@D)/image/sbl-tl.sbimg $(BINARIES_DIR)
		cp -f $(@D)/image/sbl-tl-otp.bin $(BINARIES_DIR)
	)
endef

$(eval $(generic-package))
