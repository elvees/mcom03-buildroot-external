################################################################################
#
# mcom03-dmabuf-exporter
#
################################################################################

MCOM03_DMABUF_EXPORTER_VERSION = master
MCOM03_DMABUF_EXPORTER_SITE = ssh://gerrit.elvees.com:29418/mcom03/dmabuf-exporter
MCOM03_DMABUF_EXPORTER_SITE_METHOD = git
MCOM03_DMABUF_EXPORTER_INSTALL_STAGING = YES
MCOM03_DMABUF_EXPORTER_LICENSE = GPL-2.0

define MCOM03_DMABUF_EXPORTER_INSTALL_HEADERS
	$(INSTALL) -Dm644 $(@D)/dmabuf_exporter.h $(STAGING_DIR)/usr/include/linux/
endef

MCOM03_DMABUF_EXPORTER_POST_INSTALL_STAGING_HOOKS += MCOM03_DMABUF_EXPORTER_INSTALL_HEADERS

ifeq ($(BR2_PACKAGE_MCOM03_DMABUF_EXPORTER_AUTOLOAD),y)

define MCOM03_DMABUF_EXPORTER_INSTALL_TARGET_CMDS
	echo "dmabuf_exporter" > $(TARGET_DIR)/etc/modules-load.d/dmabuf-exporter.conf
endef

endif

$(eval $(kernel-module))
$(eval $(generic-package))
