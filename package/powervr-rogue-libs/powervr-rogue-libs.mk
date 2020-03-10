################################################################################
#
# powervr-rogue-libs
#
################################################################################

POWERVR_ROGUE_LIBS_VERSION = master
POWERVR_ROGUE_LIBS_SITE = ssh://gerrit.elvees.com:29418/lib/powervr-rogue
POWERVR_ROGUE_LIBS_SITE_METHOD = git
POWERVR_ROGUE_LIBS_LICENSE = Proprietary

POWERVR_ROGUE_LIBS_DEPENDENCIES = libdrm

# this package requires custom llvm
POWERVR_ROGUE_LIBS_LLVM_DIR=$(@D)/llvm

# this package requires custom nnvm
POWERVR_ROGUE_LIBS_NNVM_DIR=$(@D)/nnvm

# mandatory options
POWERVR_ROGUE_LIBS_SETTINGS = \
	PVR_BUILD_DIR=mcom03 \
	KERNELDIR=$(LINUX_DIR) \
	ARCH=$(KERNEL_ARCH) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	DISCIMAGE=$(TARGET_DIR) \
	MIPS_ELF_ROOT=/usr/corp/Projects/ipcam-vip1/toolchain/mips/mti/bare/2015.10 \
	LLVM_BUILD_DIR=$(POWERVR_ROGUE_LIBS_LLVM_DIR) \
	NNVM_BUILD_DIR=$(POWERVR_ROGUE_LIBS_NNVM_DIR)

# setup window system.
POWERVR_ROGUE_LIBS_SETTINGS += \
	WINDOW_SYSTEM=nulldrmws

# set paths suitable for target rootfs
POWERVR_ROGUE_LIBS_SETTINGS += \
	BIN_DESTDIR=/usr/bin \
	SHARE_DESTDIR=/usr/share \
	SHLIB_DESTDIR=/usr/lib

ifeq ($(BR2_PACKAGE_POWERVR_ROGUE_LIBS_DEBUG),y)
POWERVR_ROGUE_LIBS_SETTINGS += \
	BUILD=debug \
	PVRSRV_NEED_PVR_DPF=1 \
	PVRSRV_NEED_PVR_ASSERT=1 \
	PVR_SERVICES_DEBUG=1
else
POWERVR_ROGUE_LIBS_SETTINGS += BUILD=release
endif

ifeq ($(BR2_PACKAGE_POWERVR_ROGUE_LIBS_OFFSCREEN_TESTS),y)
POWERVR_ROGUE_LIBS_SETTINGS += SUTU_DISPLAY_TYPE=offscreen
endif

define POWERVR_ROGUE_LIBS_BUILD_CMDS
	# Build LLVM, NNVM for this package
	cd $(@D); \
	    CROSS_COMPILE=$(TARGET_CROSS) ./build/linux/tools/prepare-llvm.sh \
	        -j$(PARALLEL_JOBS) $(POWERVR_ROGUE_LIBS_LLVM_DIR) Release; \
	    CROSS_COMPILE=$(TARGET_CROSS) SKIP_CHECKSUM_CHECK=1 ./build/linux/tools/prepare-nnvm.sh \
	        -j$(PARALLEL_JOBS) $(POWERVR_ROGUE_LIBS_NNVM_DIR) Release

	# Build this package
	$(MAKE) -C $(@D) $(POWERVR_ROGUE_LIBS_SETTINGS)
endef

define POWERVR_ROGUE_LIBS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(POWERVR_ROGUE_LIBS_SETTINGS) install
endef

# Linux will load driver automatically
define POWERVR_ROGUE_REMOVE_INIT
	rm -rf $(TARGET_DIR)/etc/init.d/rc.pvr
endef

POWERVR_ROGUE_LIBS_POST_INSTALL_TARGET_HOOKS += POWERVR_ROGUE_REMOVE_INIT

$(eval $(generic-package))
