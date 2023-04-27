################################################################################
#
# bootrom-tools
#
################################################################################

HOST_BOOTROM_TOOLS_VERSION = 2022-06-09
HOST_BOOTROM_TOOLS_SOURCE = bootrom-tools.$(HOST_BOOTROM_TOOLS_VERSION).tar.gz
HOST_BOOTROM_TOOLS_SITE = https://callisto.elvees.com/share/mcom03/boottools

HOST_BOOTROM_TOOLS_INSTALL_DIR = $(HOST_DIR)/opt/bootrom-tools

define HOST_BOOTROM_TOOLS_INSTALL_CMDS
	mkdir -p $(HOST_BOOTROM_TOOLS_INSTALL_DIR)
	cp -rf $(@D)/* $(HOST_BOOTROM_TOOLS_INSTALL_DIR)
endef

$(eval $(host-generic-package))
