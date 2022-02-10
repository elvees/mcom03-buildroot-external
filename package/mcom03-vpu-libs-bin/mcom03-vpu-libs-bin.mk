################################################################################
#
# mcom03-vpu-libs-bin
#
################################################################################

MCOM03_VPU_LIBS_BIN_VERSION = c0bbdc4-20220210
MCOM03_VPU_LIBS_BIN_SITE = http://dist.elvees.com/mcom03/packages/mcom03-vpu-libs
MCOM03_VPU_LIBS_BIN_STRIP_COMPONENTS = 0

define MCOM03_VPU_LIBS_BIN_INSTALL_TARGET_CMDS
	cp -dpfr $(@D)/* $(TARGET_DIR)
endef

$(eval $(generic-package))
