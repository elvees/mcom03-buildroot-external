################################################################################
#
# mcom03-tl-sbimg
#
################################################################################

MCOM03_TL_SBIMG_VERSION = $(call qstrip,$(BR2_PACKAGE_MCOM03_TL_SBIMG_REPO_VERSION))
MCOM03_TL_SBIMG_SITE = git@git.elvees.com:TrustLab-Engineers-Internal/sbimg_cfg.git
MCOM03_TL_SBIMG_SITE_METHOD = git

MCOM03_TL_SBIMG_DEPENDENCIES = host-bootrom-tools \
	ddrinit mcom03-hwinit mcom03-sbl-tl mcom03-tl-common arm-trusted-firmware uboot

MCOM03_TL_SBIMG_INSTALL_TARGET = NO
MCOM03_TL_SBIMG_INSTALL_IMAGES = YES

MCOM03_TL_SBIMG_CERT_URL = $(call qstrip,$(BR2_PACKAGE_MCOM03_TL_SBIMG_CERT_URL))

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
	MCOM03_TL_SBIMG_ROOT_CA=$(@D)/cert/rootCA.der \
	MCOM03_TL_SBIMG_NON_ROOT_CA=$(@D)/cert/nonRootCA.der \
	MCOM03_TL_SBIMG_FW_CA=$(@D)/cert/fwCA.der \
	MCOM03_TL_SBIMG_FW_PK=$(@D)/cert/fwPrivateKey.der \
	MCOM03_TL_SBIMG_DDRINIT_DEFCONFIGS=$(MCOM03_TL_SBIMG_DDRINIT_DEFCONFIGS)

define MCOM03_TL_SBIMG_DOWNLOAD_CERT
	mkdir -p $(@D)/cert
	wget -O $(@D)/cert/rootCA.der $(MCOM03_TL_SBIMG_CERT_URL)/rootCA.der
	wget -O $(@D)/cert/nonRootCA.der $(MCOM03_TL_SBIMG_CERT_URL)/nonRootCA.der
	wget -O $(@D)/cert/fwCA.der $(MCOM03_TL_SBIMG_CERT_URL)/fwCA.der
	wget -O $(@D)/cert/fwPrivateKey.der \
		$(MCOM03_TL_SBIMG_CERT_URL)/fwPrivateKey.der
endef

MCOM03_TL_SBIMG_POST_DOWNLOAD_HOOKS += MCOM03_TL_SBIMG_DOWNLOAD_CERT

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
