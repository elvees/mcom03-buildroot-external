################################################################################
#
# mcom03-rogue-modules
#
################################################################################

MCOM03_ROGUE_MODULES_VERSION = elvees-1.9.y
MCOM03_ROGUE_MODULES_SITE = ssh://gerrit.elvees.com:29418/mcom03/rogue-modules
MCOM03_ROGUE_MODULES_SITE_METHOD = git
MCOM03_ROGUE_MODULES_LICENSE = MIT

MCOM03_ROGUE_MODULES_DEPENDENCIES = linux

# mandatory options
MCOM03_ROGUE_MODULES_SETTINGS = \
	PVR_BUILD_DIR=mcom03 \
	KERNELDIR=$(LINUX_DIR) \
	ARCH=$(KERNEL_ARCH) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	DISCIMAGE=$(TARGET_DIR)

# setup window system.
MCOM03_ROGUE_MODULES_SETTINGS += \
	WINDOW_SYSTEM=lws-generic

ifeq ($(BR2_PACKAGE_MCOM03_ROGUE_MODULES_DEBUG),y)
MCOM03_ROGUE_MODULES_SETTINGS += \
	BUILD=debug \
	PVRSRV_NEED_PVR_DPF=1 \
	PVRSRV_NEED_PVR_ASSERT=1 \
	PVR_SERVICES_DEBUG=1
else
MCOM03_ROGUE_MODULES_SETTINGS += BUILD=release
endif

ifeq ($(BR2_PACKAGE_MCOM03_ROGUE_MODULES_PDUMP),y)
MCOM03_ROGUE_MODULES_SETTINGS += PDUMP=1
else
MCOM03_ROGUE_MODULES_SETTINGS += PDUMP=0
endif

define MCOM03_ROGUE_MODULES_BUILD_CMDS
	$(MAKE) -C $(@D) $(MCOM03_ROGUE_MODULES_SETTINGS)
endef

define MCOM03_ROGUE_MODULES_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(MCOM03_ROGUE_MODULES_SETTINGS) install
endef

define MCOM03_ROGUE_MODULES_DEPMOD
	$(HOST_DIR)/sbin/depmod -b $(TARGET_DIR) $(LINUX_VERSION_PROBED)
endef

MCOM03_ROGUE_MODULES_POST_INSTALL_TARGET_HOOKS += MCOM03_ROGUE_MODULES_DEPMOD

$(eval $(generic-package))
