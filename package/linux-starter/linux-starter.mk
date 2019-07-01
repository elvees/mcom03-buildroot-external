################################################################################
#
# linux-starter
#
################################################################################

LINUX_STARTER_VERSION = 0.1
LINUX_STARTER_SITE = $(LINUX_STARTER_PKGDIR)/src
LINUX_STARTER_SITE_METHOD = local
LINUX_STARTER_LICENSE = GPL

LINUX_STARTER_INSTALL_IMAGES = YES
LINUX_STARTER_INSTALL_TARGET = NO

define LINUX_STARTER_BUILD_CMDS
	$(TARGET_AS) -o $(@D)/linux-starter.o $(@D)/linux-starter.s
	$(TARGET_LD) -o $(@D)/linux-starter.elf $(@D)/linux-starter.o -Ttext 0xC0000000
	$(TARGET_OBJCOPY) $(@D)/linux-starter.elf $(@D)/linux-starter.bin -S -O binary
endef

define LINUX_STARTER_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0755 $(@D)/linux-starter.bin $(BINARIES_DIR)
endef

$(eval $(generic-package))
