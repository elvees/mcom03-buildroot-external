################################################################################
#
# toolchain-mipsel-elvees-elf32
#
################################################################################

HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_SOURCE = MCom03-console-SDK.linux64.2022-01-17.tar.gz
HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_SITE = http://dwarf.elvees.com:8080/view/SDK/job/MCOM03_SDK/job/master/26/artifact/
HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_DIR = $(HOST_DIR)/opt/toolchain-mipsel-elvees-elf32
HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_CMAKE_FILE = $(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_DIR)/share/cmake/toolchain.cmake

define HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_CMDS
	mkdir -p $(dir $(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_DIR))
	cp -r $(@D)/gcc-mipsel-elf32_linux $(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_DIR)
endef

define HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_EXTRAS
	$(INSTALL) -D -m 0644 $(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_PKGDIR)/toolchain.cmake \
		$(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_CMAKE_FILE)
endef

HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_POST_INSTALL_HOOKS += HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_EXTRAS

$(eval $(host-generic-package))
