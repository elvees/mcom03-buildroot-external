################################################################################
#
# powervr-rogue-kern
#
################################################################################

POWERVR_ROGUE_KERN_VERSION = master
POWERVR_ROGUE_KERN_SITE = ssh://gerrit.elvees.com:29418/linux/modules/powervr-rogue
POWERVR_ROGUE_KERN_SITE_METHOD = git
POWERVR_ROGUE_KERN_LICENSE = Proprietary

POWERVR_ROGUE_KERN_DEPENDENCIES = linux

# mandatory options
POWERVR_ROGUE_KERN_SETTINGS = \
	PVR_BUILD_DIR=mcom03 \
	KERNELDIR=$(LINUX_DIR) \
	ARCH=$(KERNEL_ARCH) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	DISCIMAGE=$(TARGET_DIR)

# setup window system.
POWERVR_ROGUE_KERN_SETTINGS += \
	WINDOW_SYSTEM=nulldrmws

ifeq ($(BR2_PACKAGE_POWERVR_ROGUE_KERN_DEBUG),y)
POWERVR_ROGUE_KERN_SETTINGS += \
	BUILD=debug \
	PVRSRV_NEED_PVR_DPF=1 \
	PVRSRV_NEED_PVR_ASSERT=1 \
	PVR_SERVICES_DEBUG=1
else
POWERVR_ROGUE_KERN_SETTINGS += BUILD=release
endif

define POWERVR_ROGUE_KERN_BUILD_CMDS
	$(MAKE) -C $(@D) $(POWERVR_ROGUE_KERN_SETTINGS)
endef

define POWERVR_ROGUE_KERN_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(POWERVR_ROGUE_KERN_SETTINGS) install
endef

define POWERVR_ROGUE_KERN_DEPMOD
	$(HOST_DIR)/sbin/depmod -b $(TARGET_DIR) $(LINUX_VERSION_PROBED)
endef

POWERVR_ROGUE_KERN_POST_INSTALL_TARGET_HOOKS += POWERVR_ROGUE_KERN_DEPMOD

$(eval $(generic-package))
