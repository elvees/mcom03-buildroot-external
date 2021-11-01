################################################################################
#
# gst-felix
#
################################################################################

GST_FELIX_VERSION = master
GST_FELIX_SITE_METHOD = git
GST_FELIX_SITE = ssh://gerrit.elvees.com:29418/lib/gst-felix
GST_FELIX_DEPENDENCIES = gstreamer1 mcom03-felix sensor-phy
GST_FELIX_INSTALL_STAGING = YES
GST_FELIX_SUBDIR = src
GST_FELIX_CONF_OPTS = -DCI_EXT_DATA_GENERATOR=0
GST_FELIX_CONF_OPTS += -DFELIX_SOURCE_DIR=$(MCOM03_FELIX_DIR)/DDKSource
GST_FELIX_CONF_OPTS += -DFELIX_BINARY_DIR=$(MCOM03_FELIX_BUILDDIR)
GST_FELIX_CONF_OPTS += -DPAGE_SIZE_16K=$(shell grep -wc 'CONFIG_PAGE_SIZE_16KB=y' $(LINUX_DIR)/.config)

ifeq ($(BR2_LINUX_KERNEL),y)
GST_FELIX_CONF_OPTS += -DLINUX_KERNEL_BUILD_DIR=$(LINUX_DIR)
endif

$(eval $(cmake-package))
