################################################################################
#
# mali-vpu-kern
#
################################################################################

MALI_VPU_KERN_VERSION = master
MALI_VPU_KERN_SITE = https://gerrit.elvees.com/linux/modules/mali-vpu
MALI_VPU_KERN_SITE_METHOD = git
MALI_VPU_KERN_LICENSE = GPL-2
MALI_VPU_KERN_INSTALL_STAGING = YES

# module options set
MALI_VPU_KERN_OPS = \
	CONFIG_MALI_VPU=m \
	CONFIG_MALI_VPU_DEVICE_TREE=y

ifeq ($(BR2_PACKAGE_MALI_VPU_KERN_DEBUG),y)
MALI_VPU_KERN_OPS += \
	CONFIG_MALI_VPU_ENABLE_FTRACE=y \
	CONFIG_MALI_VPU_ENABLE_PRINT_FILE=y \
	CONFIG_MALI_VPU_DEBUG=y \
	CONFIG_MALI_VPU_TRACKMEM=y \
	CONFIG_MALI_VPU_RESFAIL=y
endif

ifeq ($(BR2_PACKAGE_MALI_VPU_KERN_DISABLE_WDOG),y)
MALI_VPU_KERN_OPS += \
	CONFIG_MALI_VPU_DISABLE_WATCHDOG=y
endif

ifeq ($(BR2_PACKAGE_MALI_VPU_KERN_CLOCK_GATING),y)
MALI_VPU_KERN_OPS += \
	CONFIG_MALI_VPU_POWER_SAVING_MODE_CLOCK_GATING=y
endif

ifeq ($(BR2_PACKAGE_MALI_VPU_KERN_DVFS),y)
MALI_VPU_KERN_OPS += \
	CONFIG_MALI_VPU_ENABLE_DVFS_SIM=y
endif

# platform option
MALI_VPU_KERN_PLATFORM = \
	CONFIG_MALI_VPU_VEX7=y

# user space files
UAPI_FILES= \
	mve_base.h \
	mve_protocol_def.h \
	mve_protocol_kernel.h \
	mve_rsrc_log.h mve_rsrc_log_ram.h \
	mve_coresched_reg.h

FIRMWARE_FILES= \
	h264dec.fwb h264enc.fwb \
	hevcdec.fwb hevcenc.fwb \
	jpegdec.fwb jpegenc.fwb \
	mpeg2dec.fwb mpeg4dec.fwb \
	vc1dec.fwb vp8dec.fwb \
	vp8enc.fwb vp9dec.fwb

MALI_VPU_KERN_MODULE_SUBDIRS = drivers/video/arm/v5xx

MALI_VPU_KERN_MODULE_MAKE_OPTS = \
	KDIR=$(LINUX_DIR) \
	ARCH=$(KERNEL_ARCH) \
	$(MALI_VPU_KERN_OPS) \
	$(MALI_VPU_KERN_PLATFORM)

define MALI_VPU_KERN_INSTALL_STAGING_CMDS
	for i in $(UAPI_FILES); do \
	    $(INSTALL) -D -m 0644 \
		`find $(@D) -name $$i` \
		$(STAGING_DIR)/usr/include/linux/mve/$$i; \
	done
endef

define MALI_VPU_KERN_INSTALL_TARGET_CMDS
	for i in $(FIRMWARE_FILES) ; do \
	    $(INSTALL) -D -m 0644 \
		`find $(@D) -name $$i` \
		$(TARGET_DIR)/lib/firmware/$$i; \
	done
endef

$(eval $(kernel-module))
$(eval $(generic-package))
