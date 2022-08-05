################################################################################
#
# bootrom-tools
#
################################################################################

HOST_BOOTROM_TOOLS_VERSION = master
HOST_BOOTROM_TOOLS_SITE = git@git.elvees.com:TrustLab-Engineers-Internal/bootrom_tools.git
HOST_BOOTROM_TOOLS_SITE_METHOD = git

HOST_BOOTROM_TOOLS_INSTALL_DIR = $(HOST_DIR)/opt/bootrom-tools

define HOST_BOOTROM_TOOLS_INSTALL_CMDS
	mkdir -p $(HOST_BOOTROM_TOOLS_INSTALL_DIR)
	cp -rf $(@D)/* $(HOST_BOOTROM_TOOLS_INSTALL_DIR)
endef

$(eval $(host-generic-package))
