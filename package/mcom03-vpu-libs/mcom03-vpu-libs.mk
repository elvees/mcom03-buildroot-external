################################################################################
#
# mcom03-vpu-libs
#
################################################################################

MCOM03_VPU_LIBS_VERSION = master
MCOM03_VPU_LIBS_SITE = ssh://gerrit.elvees.com:29418/mcom03/vpu-libs
MCOM03_VPU_LIBS_SITE_METHOD = git
MCOM03_VPU_LIBS_LICENSE = Proprietary
MCOM03_VPU_LIBS_INSTALL_IMAGES = YES

MCOM03_VPU_LIBS_DEPENDENCIES = \
	host-scons \
	mali-vpu-kern \
	jpeg-turbo

MCOM03_VPU_LIBS_SCONS_ENV = -j$(PARALLEL_JOBS)

MCOM03_VPU_LIBS_SCONS_OPTS = arch=arm_v8 selfie=1 oob=1 unit=1

define MCOM03_VPU_LIBS_BUILD_CMDS
	(cd $(@D); \
	export CROSS_COMPILE=$(TARGET_CROSS); \
	$(HOST_DIR)/bin/python $(SCONS) \
	$(MCOM03_VPU_LIBS_SCONS_ENV) \
	$(MCOM03_VPU_LIBS_SCONS_OPTS))
endef

MCOM03_VPU_LIBS_FILES_LIB = \
	$(wildcard $(@D)/bin/arm_v8-linux/libjpeg_hw.so.*.*) \
	$(wildcard $(@D)/bin/arm_v8-linux/libmveomx.so.*.*) \
	$(wildcard $(@D)/bin/arm_v8-linux/libselfie.so.*.*)

MCOM03_VPU_LIBS_FILES_BIN = \
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

MCOM03_VPU_LIBS_TARGET_FILES = \
	$(addprefix usr/bin/,$(notdir $(MCOM03_VPU_LIBS_FILES_BIN))) \
	$(addprefix usr/lib/,$(notdir $(MCOM03_VPU_LIBS_FILES_LIB)))

define MCOM03_VPU_LIBS_INSTALL_TARGET_CMDS
	$(INSTALL) -Dm0755 $(MCOM03_VPU_LIBS_FILES_LIB) $(TARGET_DIR)/usr/lib/
	$(INSTALL) -Dm0755 $(MCOM03_VPU_LIBS_FILES_BIN) $(TARGET_DIR)/usr/bin/
endef

ifneq ($(MCOM03_VPU_LIBS_OVERRIDE_SRCDIR),)
MCOM03_VPU_LIBS_GIT_DIR = $(MCOM03_VPU_LIBS_OVERRIDE_SRCDIR)
else
MCOM03_VPU_LIBS_GIT_DIR = $(MCOM03_VPU_LIBS_DL_DIR)/git
endif

MCOM03_VPU_LIBS_TARBALL_VERSION = $(shell git -C $(MCOM03_VPU_LIBS_GIT_DIR) describe --always || echo "unknown")-$(shell date +%Y%m%d)

# Create tarball so that mcom03-mali-vpu-libs package can use it
define MCOM03_VPU_LIBS_INSTALL_IMAGES_CMDS
	tar -C $(TARGET_DIR) -czf \
		$(BINARIES_DIR)/mcom03-vpu-libs-bin-$(MCOM03_VPU_LIBS_TARBALL_VERSION).tar.gz \
		$(MCOM03_VPU_LIBS_TARGET_FILES)
endef

$(eval $(generic-package))
