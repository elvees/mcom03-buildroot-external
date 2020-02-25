################################################################################
#
# uboot
#
################################################################################

define UBOOT_INSTALL_DTBS_MCOM03
	find $(@D)/arch/arm/dts -name mcom03-*.dtb -exec cp '{}' $(BASE_DIR)/images \;
endef

UBOOT_POST_INSTALL_IMAGES_HOOKS += UBOOT_INSTALL_DTBS_MCOM03
