################################################################################
#
# mcom03-tl-sbimg
#
################################################################################

MCOM03_TL_SBIMG_VERSION = $(call qstrip,$(BR2_PACKAGE_MCOM03_TL_SBIMG_REPO_VERSION))
MCOM03_TL_SBIMG_SITE = ssh://gerrit.elvees.com:29418/mcom03/tl-sbimg
MCOM03_TL_SBIMG_SITE_METHOD = git

MCOM03_TL_SBIMG_BUILD_ID = $(call qstrip,$(BUILD_ID))

MCOM03_TL_SBIMG_DEPENDENCIES = host-bootrom-tools \
	ddrinit mcom03-sbl mcom03-sbl-tl mcom03-tl-core arm-trusted-firmware uboot

MCOM03_TL_SBIMG_INSTALL_TARGET = NO
MCOM03_TL_SBIMG_INSTALL_IMAGES = YES

MCOM03_TL_SBIMG_MAKE_RECOVERY = $(BR2_PACKAGE_MCOM03_TL_SBIMG_MAKE_RECOVERY)

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

MCOM03_TL_SBIMG_DDRINIT_DTB_MAP = $(call qstrip,$(BR2_MCOM03_DDRINIT_DTB_MAP))

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
	MCOM03_TL_SBIMG_DDRINIT_DEFCONFIGS="$(MCOM03_TL_SBIMG_DDRINIT_DEFCONFIGS)" \
	MCOM03_TL_SBIMG_DDRINIT_DTB_MAP="$(MCOM03_TL_SBIMG_DDRINIT_DTB_MAP)" \
	MCOM03_TL_SBIMG_BUILD_ID=$(MCOM03_TL_SBIMG_BUILD_ID) \
	MCOM03_TL_SBIMG_MAKE_RECOVERY=$(MCOM03_TL_SBIMG_MAKE_RECOVERY)

MCOM03_TL_SBIMG_EXTRA_DOWNLOADS = $(MCOM03_TL_SBIMG_CERTS_URL)

define MCOM03_TL_SBIMG_EXTRACT_CERTS
	mkdir -p $(@D)/certs
	$(TAR) xf $(MCOM03_TL_SBIMG_CERTS_TAR) -C $(@D)/certs
endef

# Workaround for local builds
define MCOM03_TL_SBIMG_DOWNLOAD_CERTS
	if [ ! -f "$(MCOM03_TL_SBIMG_CERTS_TAR)" ]; then \
		curl $(MCOM03_TL_SBIMG_CERTS_URL) --create-dirs -o $(MCOM03_TL_SBIMG_CERTS_TAR); \
	fi
endef

MCOM03_TL_SBIMG_POST_EXTRACT_HOOKS += MCOM03_TL_SBIMG_EXTRACT_CERTS
MCOM03_TL_SBIMG_POST_RSYNC_HOOKS += MCOM03_TL_SBIMG_DOWNLOAD_CERTS MCOM03_TL_SBIMG_EXTRACT_CERTS

define MCOM03_TL_SBIMG_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MCOM03_TL_SBIMG_MAKE_OPTS)
endef

# The resulting bootrom sbimg image built with ddrinit defconfig
# <board>:bootrom:<fragment1> will have the following name:
# <board>-bootrom-<fragment1>.sbimg. Only ddrinit defconfig with
# bootrom fragment will result in producing of bootrom sbimg images.
# The resulting sbl-tl sbimg image built with DTB <dtb> will have
# the following name: sbl-tl-<dtb>.sbimg or sbl-tl-<dtb>-recovery.sbimg
# depending on package type (normal or recovery).
#
# In case of recovery package type the resulting TAR archive will contain
# package.toml, sbl-tl-otp.bin, sbl-tl-<dtb>-recovery.sbimg and
# <board>-bootrom-<fragment1>.sbimg.
# The archive will have the following name: <dtb>-recovery.tl-image.
#
# In case of normal package type the resulting TAR archive will contain package.toml,
# sbl-tl-otp.bin, sbl-tl-<dtb>.sbimg and <board>-bootrom-<fragment1>.sbimg.
# The archive will have the following name: <dtb>.tl-image.
define MCOM03_TL_SBIMG_INSTALL_IMAGES_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(MCOM03_TL_SBIMG_MAKE_OPTS) install
endef

$(eval $(generic-package))
