################################################################################
#
# sensor-phy
#
################################################################################

SENSOR_PHY_VERSION = master
SENSOR_PHY_SITE = ssh://gerrit.elvees.com:29418/linux/modules/sensor-phy
SENSOR_PHY_SITE_METHOD = git
SENSOR_PHY_INSTALL_STAGING = YES

define SENSOR_PHY_INSTALL_HEADERS
	$(INSTALL) -Dm644 $(@D)/sensor_phy.h $(STAGING_DIR)/usr/include/linux/
endef

SENSOR_PHY_POST_INSTALL_STAGING_HOOKS += SENSOR_PHY_INSTALL_HEADERS

$(eval $(kernel-module))
$(eval $(generic-package))
