################################################################################
#
# gst-felix
#
################################################################################

GST_FELIX_VERSION = master
GST_FELIX_SITE_METHOD = git
GST_FELIX_SITE = ssh://gerrit.elvees.com:29418/lib/gst-felix
GST_FELIX_DEPENDENCIES = gstreamer1 mcom03-dmabuf-exporter mcom03-felix sensor-phy
GST_FELIX_INSTALL_STAGING = YES
GST_FELIX_INSTALL_IMAGES = YES
GST_FELIX_SUBDIR = src
GST_FELIX_CONF_OPTS = -DCI_EXT_DATA_GENERATOR=0
GST_FELIX_CONF_OPTS += -DFELIX_SOURCE_DIR=$(MCOM03_FELIX_DIR)/DDKSource
GST_FELIX_CONF_OPTS += -DFELIX_BINARY_DIR=$(MCOM03_FELIX_BUILDDIR)
GST_FELIX_CONF_OPTS += -DPAGE_SIZE_16K=$(shell grep -wc 'CONFIG_PAGE_SIZE_16KB=y' $(LINUX_DIR)/.config)

GST_FELIX_TARGET_FILES = lib/gstreamer-1.0/libfelixsrc.so

ifeq ($(BR2_LINUX_KERNEL),y)
GST_FELIX_CONF_OPTS += -DLINUX_KERNEL_BUILD_DIR=$(LINUX_DIR)
endif

ifneq ($(GST_FELIX_OVERRIDE_SRCDIR),)
GST_FELIX_GIT_DIR = $(GST_FELIX_OVERRIDE_SRCDIR)
else
GST_FELIX_GIT_DIR = $(GST_FELIX_DL_DIR)/git
endif
GST_FELIX_BIN_VERSION = $(shell git -C $(GST_FELIX_GIT_DIR) describe --always || echo "unknown")-$(shell date +%Y%m%d)
# Create tarball with binaries
define GST_FELIX_INSTALL_IMAGES_CMDS
	tar -C $(TARGET_DIR) -czf \
		$(BINARIES_DIR)/gst-felix-$(GST_FELIX_BIN_VERSION).tar.gz \
		$(GST_FELIX_TARGET_FILES)
endef

$(eval $(cmake-package))
