################################################################################
#
# rtl-test-stop
#
################################################################################

RTL_TEST_STOP_VERSION = 0.1
RTL_TEST_STOP_SITE = $(RTL_TEST_STOP_PKGDIR)/src
RTL_TEST_STOP_SITE_METHOD = local
RTL_TEST_STOP_LICENSE = GPL

#catch variable
RTL_BDIR=$(RTL_TEST_STOP_DIR)
RTL_FSDIR=$(RTL_TEST_STOP_DIR)/fs
RTL_FSINIT=$(RTL_TEST_STOP_DIR)/fs-init-script

MAGIC_ADDR=$(shell echo $(BR2_PACKAGE_RTL_TEST_STOP_MAGIC_ADDR))
MAGIC_VAL=$(shell echo $(BR2_PACKAGE_RTL_TEST_STOP_MAGIC_VALUE))

define RTL_TEST_STOP_BUILD_CMDS
	$(TARGET_CC) -Os -s -static $(RTL_BDIR)/bell.c -o $(RTL_BDIR)/bell \
		-DMADDR=$(MAGIC_ADDR) -DMVAL=$(MAGIC_VAL)
endef

$(eval $(generic-package))

#populate rootfs
define RTL_TEST_STOP_REPLACE_INITRAMFS
	@$(call MESSAGE,"Generating RTL initramfs")
	@echo '#!/bin/sh' > $(RTL_FSINIT)
	@echo "set -e" >> $(RTL_FSINIT)
	@echo 'rm -rf $(RTL_FSDIR)' >> $(RTL_FSINIT)
	@echo 'mkdir -p $(RTL_FSDIR)/dev' >> $(RTL_FSINIT)
	@echo 'mknod -m 0622 $(RTL_FSDIR)/dev/console c 5 1' >> $(RTL_FSINIT)
	@echo 'mknod -m 0622 $(RTL_FSDIR)/dev/mem c 1 1' >> $(RTL_FSINIT)
	@echo '$(INSTALL) -T -m 0755 $(RTL_BDIR)/bell $(RTL_FSDIR)/init' >> $(RTL_FSINIT)
	@echo 'chown 0:0 $(RTL_FSDIR)/init' >> $(RTL_FSINIT)
	@echo 'cd $(RTL_FSDIR)' >> $(RTL_FSINIT)
	@echo 'find . | cpio --quiet -o -H newc > $(RTL_BDIR)/rootfs.cpio' >> $(RTL_FSINIT)
	@chmod a+x $(RTL_FSINIT)
	@$(HOST_DIR)/bin/fakeroot -- $(RTL_FSINIT)
	@cp $(RTL_BDIR)/rootfs.cpio $(BINARIES_DIR)/rootfs.cpio
endef

ifeq ($(BR2_PACKAGE_RTL_TEST_STOP),y)
ROOTFS_CPIO_POST_GEN_HOOKS += RTL_TEST_STOP_REPLACE_INITRAMFS
endif
