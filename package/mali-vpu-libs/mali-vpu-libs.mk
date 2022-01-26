################################################################################
#
# mali-vpu-libs
#
################################################################################

MALI_VPU_LIBS_VERSION = master
MALI_VPU_LIBS_SITE = ssh://gerrit.elvees.com:29418/lib/mali-vpu
MALI_VPU_LIBS_SITE_METHOD = git
MALI_VPU_LIBS_LICENSE = Proprietary
MALI_VPU_LIBS_INSTALL_IMAGES = YES

MALI_VPU_LIBS_DEPENDENCIES = \
	host-scons \
	mali-vpu-kern \
	jpeg-turbo

MALI_VPU_LIBS_SCONS_ENV = -j$(PARALLEL_JOBS)

MALI_VPU_LIBS_SCONS_OPTS = arch=arm_v8 selfie=1 oob=1 unit=1

define MALI_VPU_LIBS_BUILD_CMDS
	(cd $(@D); \
	export CROSS_COMPILE=$(TARGET_CROSS); \
	$(HOST_DIR)/bin/python $(SCONS) \
	$(MALI_VPU_LIBS_SCONS_ENV) \
	$(MALI_VPU_LIBS_SCONS_OPTS))
endef

MALI_VPU_LIBS_FILES_LIB = \
	$(wildcard $(@D)/bin/arm_v8-linux/libjpeg_hw.so.*.*) \
	$(wildcard $(@D)/bin/arm_v8-linux/libmveomx.so.*.*) \
	$(wildcard $(@D)/bin/arm_v8-linux/libselfie.so.*.*)

MALI_VPU_LIBS_FILES_BIN = \
	$(@D)/bin/arm_v8-linux/mve_jpeg \
	$(@D)/bin/arm_v8-linux/mve_logd \
	$(@D)/bin/arm_v8-linux/mve_ots \
	$(@D)/bin/arm_v8-linux/mve_system_test_suites \
	$(@D)/bin/arm_v8-linux/mve_test_suites \
	$(@D)/bin/arm_v8-linux/mve_unit_instr \
	$(@D)/bin/arm_v8-linux/mve_unit_jpeg \
	$(@D)/bin/arm_v8-linux/mve_unit_mem \
	$(@D)/bin/arm_v8-linux/mve_unit_omx \
	$(@D)/bin/arm_v8-linux/mve_unit_util \
	$(@D)/bin/arm_v8-linux/selfie

MALI_VPU_LIBS_TARGET_FILES = \
	$(addprefix usr/bin/,$(notdir $(MALI_VPU_LIBS_FILES_BIN))) \
	$(addprefix usr/lib/,$(notdir $(MALI_VPU_LIBS_FILES_LIB)))

define MALI_VPU_LIBS_INSTALL_TARGET_CMDS
	$(INSTALL) -Dm0755 $(MALI_VPU_LIBS_FILES_LIB) $(TARGET_DIR)/usr/lib/
	$(INSTALL) -Dm0755 $(MALI_VPU_LIBS_FILES_BIN) $(TARGET_DIR)/usr/bin/
endef

ifneq ($(MALI_VPU_LIBS_OVERRIDE_SRCDIR),)
MALI_VPU_LIBS_GIT_DIR = $(MALI_VPU_LIBS_OVERRIDE_SRCDIR)
else
MALI_VPU_LIBS_GIT_DIR = $(MALI_VPU_LIBS_DL_DIR)/git
endif

MALI_VPU_LIBS_BIN_VERSION = $(shell git -C $(MALI_VPU_LIBS_GIT_DIR) describe --always || echo "unknown")-$(shell date +%Y%m%d)

# Create tarball so that mcom03-mali-vpu-libs package can use it
define MALI_VPU_LIBS_INSTALL_IMAGES_CMDS
	tar -C $(TARGET_DIR) -czf \
		$(BINARIES_DIR)/mcom03-mali-vpu-libs-$(MALI_VPU_LIBS_BIN_VERSION).tar.gz \
		$(MALI_VPU_LIBS_TARGET_FILES)
endef

$(eval $(generic-package))
