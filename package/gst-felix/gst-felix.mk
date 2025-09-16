################################################################################
#
# gst-felix
#
################################################################################

GST_FELIX_DEPENDENCIES = gstreamer1 mcom03-dmabuf-exporter mcom03-felix

# Installation from source code
ifeq ($(BR2_PACKAGE_GST_FELIX_INSTALL_SRC),y)
GST_FELIX_VERSION = master
GST_FELIX_SITE_METHOD = git
GST_FELIX_SITE = ssh://gerrit.elvees.com:29418/lib/gst-felix
GST_FELIX_INSTALL_STAGING = YES
GST_FELIX_INSTALL_IMAGES = YES
GST_FELIX_SUBDIR = src
GST_FELIX_CONF_OPTS += -DCI_EXT_DATA_GENERATOR=0
GST_FELIX_CONF_OPTS += -DFELIX_SOURCE_DIR=$(MCOM03_FELIX_DIR)/DDKSource
GST_FELIX_CONF_OPTS += -DFELIX_BINARY_DIR=$(MCOM03_FELIX_BUILDDIR)
GST_FELIX_CONF_OPTS += -DPAGE_SIZE_16K=$(shell grep -wc 'CONFIG_PAGE_SIZE_16KB=y' $(LINUX_DIR)/.config)

GST_FELIX_TARGET_FILES = \
	lib/gstreamer-1.0/libfelixsrc.so \
	lib/libgstfelixmeta.so \
	usr/include/gstreamer-1.0/gst/gstfelixmeta.h

ifeq ($(BR2_PACKAGE_LENSCONTROL_GST_LENSCONTROL),y)
GST_FELIX_DEPENDENCIES += lenscontrol
GST_FELIX_CONF_OPTS += -DGST_LENSCONTROL_META=ON
endif

ifeq ($(BR2_LINUX_KERNEL),y)
GST_FELIX_CONF_OPTS += -DLINUX_KERNEL_BUILD_DIR=$(LINUX_DIR)
endif

ifneq ($(GST_FELIX_OVERRIDE_SRCDIR),)
GST_FELIX_GIT_DIR = $(GST_FELIX_OVERRIDE_SRCDIR)
else
GST_FELIX_GIT_DIR = $(GST_FELIX_DL_DIR)/git
endif

# Create tarball with binaries
define GST_FELIX_INSTALL_IMAGES_CMDS
	tar -C $(TARGET_DIR) -czf \
		$(BINARIES_DIR)/$(call TARBALL_NAME,GST_FELIX).gz \
		$(GST_FELIX_TARGET_FILES)
endef

$(eval $(cmake-package))

# Installation from tarball with binaries
else
GST_FELIX_VERSION = latest
GST_FELIX_SITE = $(BR2_ELVEES_BINARY_PACKAGES_SITE)/gst-felix
GST_FELIX_STRIP_COMPONENTS = 0

define GST_FELIX_INSTALL_TARGET_CMDS
	rsync -aK $(@D)/* $(TARGET_DIR)
endef

$(eval $(generic-package))

endif
