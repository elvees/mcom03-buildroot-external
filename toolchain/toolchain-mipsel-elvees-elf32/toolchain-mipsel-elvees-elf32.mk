################################################################################
#
# toolchain-mipsel-elvees-elf32
#
################################################################################

HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_SOURCE = ELVEES-MCom03-Mips32.GCC.linux64.r193114_10.2023-04-05.tar.gz
HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_SITE = https://diver.elvees.com/pub/tools_linux/mips-tools11.2.0-mcom03
HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_DIR = $(HOST_DIR)/opt/toolchain-mipsel-elvees-elf32
HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_CMAKE_FILE = $(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_DIR)/share/cmake/toolchain.cmake

# site uses self-signed certificates
HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_DL_OPTS = --no-check-certificate

define HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_CMDS
	mkdir -p $(dir $(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_DIR))
	cp -r $(@D) $(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_DIR)
endef

define HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_EXTRAS
	$(INSTALL) -D -m 0644 $(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_PKGDIR)/toolchain.cmake \
		$(HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_CMAKE_FILE)
endef

HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_POST_INSTALL_HOOKS += HOST_TOOLCHAIN_MIPSEL_ELVEES_ELF32_INSTALL_EXTRAS

$(eval $(host-generic-package))
