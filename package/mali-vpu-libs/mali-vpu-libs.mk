################################################################################
#
# mali-vpu-libs
#
################################################################################

MALI_VPU_LIBS_VERSION = master
MALI_VPU_LIBS_SITE = ssh://gerrit.elvees.com:29418/lib/mali-vpu
MALI_VPU_LIBS_SITE_METHOD = git
MALI_VPU_LIBS_LICENSE = Proprietary

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

define MALI_VPU_LIBS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/libjpeg_hw.so.*.* $(TARGET_DIR)/usr/lib
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/libmveomx.so.*.* $(TARGET_DIR)/usr/lib
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/libselfie.so.*.* $(TARGET_DIR)/usr/lib
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/mve_jpeg $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/mve_logd $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/mve_ots $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/mve_system_test_suites $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/mve_test_suites $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/mve_unit_instr $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/mve_unit_jpeg $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/mve_unit_mem $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/mve_unit_omx $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/mve_unit_util $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/bin/arm_v8-linux/selfie $(TARGET_DIR)/usr/bin
endef

$(eval $(generic-package))
