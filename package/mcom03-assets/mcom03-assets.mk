################################################################################
#
# mcom03-assets
#
################################################################################

MCOM03_ASSETS_VERSION = 0.1.0
MCOM03_ASSETS_SOURCE =
# Do not use SITE + EXTRA_DOWNLOADS method here because it does not save the
# assets' directory structure. Use post-download hook instead to download the
# assets manually

MCOM03_ASSETS_LIST = $(shell cat $(call qstrip,$(BR2_PACKAGE_MCOM03_ASSETS_LISTING)))

define MCOM03_ASSETS_DOWNLOAD
	$(foreach asset,$(MCOM03_ASSETS_LIST),wget \
		--directory-prefix=$(dir $(call qstrip,$(MCOM03_ASSETS_DL_DIR))/$(asset)) \
		$(call qstrip,$(BR2_PACKAGE_MCOM03_ASSETS_ORIGIN))/$(asset)
	)
endef # MCOM03_ASSETS_DOWNLOAD

MCOM03_ASSETS_POST_DOWNLOAD_HOOKS += MCOM03_ASSETS_DOWNLOAD

define MCOM03_ASSETS_INSTALL_TARGET_CMDS
	$(foreach asset,$(MCOM03_ASSETS_LIST),$(INSTALL) -D --verbose \
		$(MCOM03_ASSETS_DL_DIR)/$(asset) \
		$(TARGET_DIR)$(call qstrip,$(BR2_PACKAGE_MCOM03_ASSETS_TARGET))/$(asset)
	)
endef # MCOM03_ASSETS_INSTALL_TARGET_CMDS

$(eval $(generic-package))
