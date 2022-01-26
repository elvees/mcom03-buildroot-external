################################################################################
#
# mcom03-mali-vpu-libs
#
################################################################################

MCOM03_MALI_VPU_LIBS_SOURCE = mcom03-mali-vpu-libs-c0bbdc4-20220207.tar.gz
MCOM03_MALI_VPU_LIBS_SITE = http://dist.elvees.com/mcom03/packages/mali-vpu-libs
MCOM03_MALI_VPU_LIBS_STRIP_COMPONENTS = 0
MCOM03_MALI_VPU_LIBS_INSTALL_STAGING = YES

define MCOM03_MALI_VPU_LIBS_INSTALL_CMDS
	cp -dpfr $(@D)/* $(1)
endef

MCOM03_MALI_VPU_LIBS_INSTALL_TARGET_CMDS = $(call MCOM03_MALI_VPU_LIBS_INSTALL_CMDS,$(TARGET_DIR))
MCOM03_MALI_VPU_LIBS_INSTALL_STAGING_CMDS = $(call MCOM03_MALI_VPU_LIBS_INSTALL_CMDS,$(STAGING_DIR))

$(eval $(generic-package))
