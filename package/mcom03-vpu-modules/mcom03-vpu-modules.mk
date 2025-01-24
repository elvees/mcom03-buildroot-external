################################################################################
#
# mcom03-vpu-modules
#
################################################################################

MCOM03_VPU_MODULES_VERSION = $(call qstrip,$(BR2_PACKAGE_MCOM03_VPU_MODULES_VERSION))
MCOM03_VPU_MODULES_SITE = ssh://gerrit.elvees.com:29418/mcom03/vpu-modules
MCOM03_VPU_MODULES_SITE_METHOD = git
MCOM03_VPU_MODULES_LICENSE = GPL-2
MCOM03_VPU_MODULES_INSTALL_STAGING = YES

# module options set
MCOM03_VPU_MODULES_OPS = \
	CONFIG_MALI_VPU=m \
	CONFIG_MALI_VPU_DEVICE_TREE=y

ifeq ($(BR2_PACKAGE_MCOM03_VPU_MODULES_DEBUG),y)
MCOM03_VPU_MODULES_OPS += \
	CONFIG_MALI_VPU_ENABLE_FTRACE=y \
	CONFIG_MALI_VPU_ENABLE_PRINT_FILE=y \
	CONFIG_MALI_VPU_DEBUG=y \
	CONFIG_MALI_VPU_TRACKMEM=y \
	CONFIG_MALI_VPU_RESFAIL=y
endif

ifeq ($(BR2_PACKAGE_MCOM03_VPU_MODULES_DISABLE_WDOG),y)
MCOM03_VPU_MODULES_OPS += \
	CONFIG_MALI_VPU_DISABLE_WATCHDOG=y
endif

ifeq ($(BR2_PACKAGE_MCOM03_VPU_MODULES_CLOCK_GATING),y)
MCOM03_VPU_MODULES_OPS += \
	CONFIG_MALI_VPU_POWER_SAVING_MODE_CLOCK_GATING=y
endif

ifeq ($(BR2_PACKAGE_MCOM03_VPU_MODULES_DVFS),y)
MCOM03_VPU_MODULES_OPS += \
	CONFIG_MALI_VPU_ENABLE_DVFS_SIM=y
endif

# platform option
MCOM03_VPU_MODULES_PLATFORM = \
	CONFIG_MALI_VPU_MCOM03=y

# user space files
MCOM03_VPU_MODULES_UAPI_FILES= \
	mve_base.h \
	mve_protocol_def.h \
	mve_protocol_kernel.h \
	mve_rsrc_log.h mve_rsrc_log_ram.h \
	mve_coresched_reg.h

MCOM03_VPU_MODULES_FIRMWARE_FILES= \
	h264dec.fwb h264enc.fwb \
	hevcdec.fwb hevcenc.fwb \
	jpegdec.fwb jpegenc.fwb \
	mpeg2dec.fwb mpeg4dec.fwb \
	vc1dec.fwb vp8dec.fwb \
	vp8enc.fwb vp9dec.fwb

MCOM03_VPU_MODULES_MODULE_SUBDIRS = drivers/video/arm/v5xx

MCOM03_VPU_MODULES_MODULE_MAKE_OPTS = \
	KDIR=$(LINUX_DIR) \
	ARCH=$(KERNEL_ARCH) \
	$(MCOM03_VPU_MODULES_OPS) \
	$(MCOM03_VPU_MODULES_PLATFORM)

define MCOM03_VPU_MODULES_INSTALL_STAGING_CMDS
	for i in $(MCOM03_VPU_MODULES_UAPI_FILES); do \
	    $(INSTALL) -D -m 0644 \
		`find $(@D) -name $$i` \
		$(STAGING_DIR)/usr/include/linux/mve/$$i; \
	done
endef

define MCOM03_VPU_MODULES_INSTALL_TARGET_CMDS
	for i in $(MCOM03_VPU_MODULES_FIRMWARE_FILES) ; do \
	    $(INSTALL) -D -m 0644 \
		`find $(@D) -name $$i` \
		$(TARGET_DIR)/lib/firmware/$$i; \
	done
endef

$(eval $(kernel-module))
$(eval $(generic-package))
