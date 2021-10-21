################################################################################
#
# mcom03-rogue-libs
#
################################################################################

MCOM03_ROGUE_LIBS_VERSION = elvees-1.9.y
MCOM03_ROGUE_LIBS_SITE = ssh://gerrit.elvees.com:29418/mcom03/rogue-libs
MCOM03_ROGUE_LIBS_SITE_METHOD = git
MCOM03_ROGUE_LIBS_LICENSE = Proprietary

MCOM03_ROGUE_LIBS_INSTALL_IMAGES = YES

MCOM03_ROGUE_LIBS_DEPENDENCIES = host-bison \
	host-flex \
	host-python \
	libxml2 \
	libdrm

MCOM03_ROGUE_LIBS_INSTALL_STAGING = YES

MCOM03_ROGUE_LIBS_PROVIDES = libgles libopencl

# this package requires custom llvm
MCOM03_ROGUE_LIBS_LLVM_DIR=$(@D)/llvm

# this package requires custom nnvm
MCOM03_ROGUE_LIBS_NNVM_DIR=$(@D)/nnvm

# Path to the directory with binaries for tarball creation
MCOM03_ROGUE_LIBS_TARGET_FILES_DIR=$(@D)/binaries

# mandatory options
MCOM03_ROGUE_LIBS_SETTINGS = \
	PVR_BUILD_DIR=mcom03 \
	KERNELDIR=$(LINUX_DIR) \
	ARCH=$(KERNEL_ARCH) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	DISCIMAGE=$(TARGET_DIR) \
	MIPS_ELF_ROOT=/usr/corp/Projects/ipcam-vip1/toolchain/mips/mti/bare/2015.10 \
	LLVM_BUILD_DIR=$(MCOM03_ROGUE_LIBS_LLVM_DIR) \
	NNVM_BUILD_DIR=$(MCOM03_ROGUE_LIBS_NNVM_DIR) \
	SYSROOT=$(STAGING_DIR)

# setup window system.
MCOM03_ROGUE_LIBS_SETTINGS += \
	WINDOW_SYSTEM=lws-generic

# set paths suitable for target rootfs
MCOM03_ROGUE_LIBS_SETTINGS += \
	BIN_DESTDIR=/usr/bin \
	SHARE_DESTDIR=/usr/share \
	SHLIB_DESTDIR=/usr/lib

ifeq ($(BR2_PACKAGE_MCOM03_ROGUE_LIBS_DEBUG),y)
MCOM03_ROGUE_LIBS_SETTINGS += \
	BUILD=debug \
	PVRSRV_NEED_PVR_DPF=1 \
	PVRSRV_NEED_PVR_ASSERT=1 \
	PVR_SERVICES_DEBUG=1
else
MCOM03_ROGUE_LIBS_SETTINGS += BUILD=release
endif

ifeq ($(BR2_PACKAGE_MCOM03_ROGUE_LIBS_PDUMP),y)
MCOM03_ROGUE_LIBS_SETTINGS += PDUMP=1
else
MCOM03_ROGUE_LIBS_SETTINGS += PDUMP=0
endif

ifeq ($(BR2_PACKAGE_MCOM03_ROGUE_LIBS_OFFSCREEN_TESTS),y)
MCOM03_ROGUE_LIBS_SETTINGS += SUTU_DISPLAY_TYPE=offscreen
endif

define MCOM03_ROGUE_LIBS_DOWNLOAD_3RDPARTY
	$(MCOM03_ROGUE_LIBS_PKGDIR)download-llvm.sh $(MCOM03_ROGUE_LIBS_LLVM_DIR)
	$(MCOM03_ROGUE_LIBS_PKGDIR)download-nvme.sh $(MCOM03_ROGUE_LIBS_NNVM_DIR)
endef

MCOM03_ROGUE_LIBS_POST_DOWNLOAD_HOOKS += MCOM03_ROGUE_LIBS_DOWNLOAD_3RDPARTY

define MCOM03_ROGUE_LIBS_BUILD_CMDS
	# Build LLVM, NNVM for this package
	cd $(@D); \
		set -e; \
		$(HOST_MAKE_ENV) ./build/linux/tools/prepare-llvm.sh \
			-j$(PARALLEL_JOBS) $(MCOM03_ROGUE_LIBS_LLVM_DIR) Release; \
		$(TARGET_MAKE_ENV) CROSS_COMPILE=$(TARGET_CROSS) SYSROOT=$(STAGING_DIR) \
			./build/linux/tools/prepare-llvm.sh \
			-j$(PARALLEL_JOBS) $(MCOM03_ROGUE_LIBS_LLVM_DIR) Release; \
		$(TARGET_MAKE_ENV) CROSS_COMPILE=$(TARGET_CROSS) SYSROOT=$(STAGING_DIR) \
		SKIP_CHECKSUM_CHECK=1 ./build/linux/tools/prepare-nnvm.sh \
			-j$(PARALLEL_JOBS) $(MCOM03_ROGUE_LIBS_NNVM_DIR) Release

	# Build this package
	$(TARGET_MAKE_ENV) LIBCLANG_PATH=$(@D)/llvm/llvm.x86_64/lib/libclang.so \
		$(MAKE) -C $(@D) $(MCOM03_ROGUE_LIBS_SETTINGS)
endef

define MCOM03_ROGUE_LIBS_INSTALL_STAGING_CMDS
	cp -dpfr $(@D)/include/khronos/* $(STAGING_DIR)/usr/include/
	$(MAKE) -C $(@D) $(MCOM03_ROGUE_LIBS_SETTINGS) DISCIMAGE=$(STAGING_DIR) install
	$(INSTALL) -D -m 0644 $(MCOM03_ROGUE_LIBS_PKGDIR)glesv2.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/glesv2.pc
endef

define MCOM03_ROGUE_LIBS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(MCOM03_ROGUE_LIBS_SETTINGS) install
endef

define MCOM03_ROGUE_LIBS_INSTALL_IMAGES_CMDS
	# Create directory for binaries
	rm -rf $(MCOM03_ROGUE_LIBS_TARGET_FILES_DIR)
	mkdir -p $(MCOM03_ROGUE_LIBS_TARGET_FILES_DIR)

	$(MAKE) -C $(@D) $(MCOM03_ROGUE_LIBS_SETTINGS) \
		DISCIMAGE=$(MCOM03_ROGUE_LIBS_TARGET_FILES_DIR) install

	tar -C $(MCOM03_ROGUE_LIBS_TARGET_FILES_DIR) -czf $(BINARIES_DIR)/mcom03-rogue-libs-$\
		$(MCOM03_ROGUE_LIBS_VERSION)-$(shell date --iso).tar.gz .
endef

# Linux will load driver automatically
define MCOM03_ROGUE_LIBS_REMOVE_INIT
	rm -rf $(TARGET_DIR)/etc/init.d/rc.pvr
endef

MCOM03_ROGUE_LIBS_POST_INSTALL_TARGET_HOOKS += MCOM03_ROGUE_LIBS_REMOVE_INIT

$(eval $(generic-package))
