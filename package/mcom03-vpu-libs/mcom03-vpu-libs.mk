################################################################################
#
# mcom03-vpu-libs
#
################################################################################

# Force build from sources if override srcdir is enabled
ifneq ($(MCOM03_VPU_LIBS_OVERRIDE_SRCDIR),)
MCOM03_VPU_LIBS_INSTALL_SRC = y
MCOM03_VPU_LIBS_GIT_DIR = $(MCOM03_VPU_LIBS_OVERRIDE_SRCDIR)
else
MCOM03_VPU_LIBS_INSTALL_SRC = $(BR2_PACKAGE_MCOM03_VPU_LIBS_INSTALL_SRC)
MCOM03_VPU_LIBS_GIT_DIR = $(MCOM03_VPU_LIBS_DL_DIR)/git
endif

# Installation from source code
ifeq ($(MCOM03_VPU_LIBS_INSTALL_SRC),y)
MCOM03_VPU_LIBS_VERSION = master
MCOM03_VPU_LIBS_SITE = ssh://gerrit.elvees.com:29418/mcom03/vpu-libs
MCOM03_VPU_LIBS_SITE_METHOD = git
MCOM03_VPU_LIBS_LICENSE = Proprietary
MCOM03_VPU_LIBS_INSTALL_IMAGES = YES
MCOM03_VPU_LIBS_INSTALL_STAGING = YES

MCOM03_VPU_LIBS_DEPENDENCIES = \
	host-scons \
	mcom03-vpu-modules \
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

MCOM03_VPU_LIBS_TARBALL_VERSION = $(shell git -C $(MCOM03_VPU_LIBS_GIT_DIR) describe --always || echo "unknown")-$(shell date +%Y%m%d)

define MCOM03_VPU_LIBS_INSTALL_IMAGES_CMDS
	tar -C $(TARGET_DIR) -cf \
		$(BINARIES_DIR)/mcom03-vpu-libs-$(MCOM03_VPU_LIBS_TARBALL_VERSION).tar \
		$(MCOM03_VPU_LIBS_TARGET_FILES) --transform 's,^,target/,'
	tar -C $(STAGING_DIR) -rf \
		$(BINARIES_DIR)/mcom03-vpu-libs-$(MCOM03_VPU_LIBS_TARBALL_VERSION).tar \
		usr/include/IL --transform 's,^,staging/,'
	gzip -f $(BINARIES_DIR)/mcom03-vpu-libs-$(MCOM03_VPU_LIBS_TARBALL_VERSION).tar
endef

define MCOM03_VPU_LIBS_INSTALL_STAGING_CMDS
	$(INSTALL) -d $(STAGING_DIR)/usr/include/IL
	$(INSTALL) -m 0644 -t $(STAGING_DIR)/usr/include/IL $(@D)/khronos/original/OMXIL/1.1.2/*
endef

# Installation from tarball with binaries
else
MCOM03_VPU_LIBS_VERSION = latest
MCOM03_VPU_LIBS_SITE = $(BR2_ELVEES_BINARY_PACKAGES_SITE)/mcom03-vpu-libs
MCOM03_VPU_LIBS_STRIP_COMPONENTS = 0

define MCOM03_VPU_LIBS_INSTALL_TARGET_CMDS
	cp -dpfr $(@D)/target/* $(TARGET_DIR)
	cp -dpfr $(@D)/staging/* $(STAGING_DIR)
endef

endif

$(eval $(generic-package))
