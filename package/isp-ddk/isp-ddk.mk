################################################################################
#
# isp-ddk
#
################################################################################

ISP_DDK_VERSION = master
ISP_DDK_SITE_METHOD = git
ISP_DDK_SITE = ssh://gerrit.elvees.com:29418/driver/v2505-isp
ISP_DDK_DEPENDENCIES = linux
ISP_DDK_SUBDIR = DDKSource

ISP_DDK_INSTALL_LOCAL = $(@D)/install
ISP_DDK_INSTALL_BIN = $(TARGET_DIR)/usr/bin
ISP_DDK_INSTALL_MOD =  $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)
ISP_DDK_INSTALL_CONFIG = $(TARGET_DIR)/usr/share/isp/data

# 1 => enable driver debug functions
ISP_DDK_CI_DEBUG_FUNCTIONS=1
# 0 => internal data generator; 1 => external data generator
ISP_DDK_CI_EXT_DATA_GENERATOR=0

ISP_DDK_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
ISP_DDK_CONF_OPTS += -DCMAKE_INSTALL_PREFIX=$(ISP_DDK_INSTALL_LOCAL)

ISP_DDK_CONF_OPTS += -DLINUX_KERNEL_ARCH="ARCH=$(KERNEL_ARCH)"
ISP_DDK_CONF_OPTS += -DLINUX_KERNEL_CROSS_COMPILE="CROSS_COMPILE=$(TARGET_CROSS)"
ISP_DDK_CONF_OPTS += -DLINUX_KERNEL_BUILD_DIR=$(LINUX_DIR)

ISP_DDK_CONF_OPTS += -DBUILD_SCB_DRIVER=OFF
ISP_DDK_CONF_OPTS += -DBUILD_UNIT_TESTS=OFF
ISP_DDK_CONF_OPTS += -DCI_ALLOC=CARVEOUT
ISP_DDK_CONF_OPTS += -DCI_BUILD_KERNEL_MODULE=ON
ISP_DDK_CONF_OPTS += -DCI_DEBUG_FUNCTIONS=$(ISP_DDK_CI_DEBUG_FUNCTIONS)
ISP_DDK_CONF_OPTS += -DCI_DEVICE=DEVICE_TREE
ISP_DDK_CONF_OPTS += -DCI_EXT_DATA_GENERATOR=$(ISP_DDK_CI_EXT_DATA_GENERATOR)
ISP_DDK_CONF_OPTS += -DFELIX_PDP=OFF

ifeq ($(BR2_PACKAGE_ISP_DDK_SENSOR_PARAXDMA_LINUX),y)
ISP_DDK_CONF_OPTS += -DSENSOR_PARAXDMA_LINUX=1
define ISP_DDK_SENSOR_PARAXDMA_CONFIG_INSTALL
	mkdir -p $(ISP_DDK_INSTALL_CONFIG)/paraxdma
	$(INSTALL) -D -m 0644 $(@D)/haps-tests/setup-args-para*.txt $(ISP_DDK_INSTALL_CONFIG)/paraxdma
endef
endif

ifeq ($(BR2_PACKAGE_ISP_DDK_ISPC_TEST),y)
define ISP_DDK_ISPC_TEST_INSTALL
	$(INSTALL) -D -m 0755 $(ISP_DDK_INSTALL_LOCAL)/ISPC/ISPC_test $(ISP_DDK_INSTALL_BIN)/ISPC_test
endef
endif

ifeq ($(BR2_PACKAGE_ISP_DDK_ISPC_LOOP),y)
define ISP_DDK_ISPC_LOOP_INSTALL
	$(INSTALL) -D -m 0755 $(ISP_DDK_INSTALL_LOCAL)/ISPC/ISPC_loop $(ISP_DDK_INSTALL_BIN)/ISPC_loop
endef
endif

ifeq ($(BR2_PACKAGE_ISP_DDK_DRIVER_TEST),y)
define ISP_DDK_DRIVER_TEST_INSTALL
	$(INSTALL) -D -m 0755 $(ISP_DDK_INSTALL_LOCAL)/CI/driver_test $(ISP_DDK_INSTALL_BIN)/driver_test
endef
endif

define ISP_DDK_INSTALL_TARGET_CMDS
	make -C $(@D)/$(ISP_DDK_SUBDIR) install
	$(INSTALL) -D -m 0644 $(ISP_DDK_INSTALL_LOCAL)/km/Felix.ko $(ISP_DDK_INSTALL_MOD)/extra/Felix.ko
	depmod -b $(TARGET_DIR) $(LINUX_VERSION_PROBED)
	$(ISP_DDK_SENSOR_PARAXDMA_CONFIG_INSTALL)
	$(ISP_DDK_ISPC_TEST_INSTALL)
	$(ISP_DDK_ISPC_LOOP_INSTALL)
	$(ISP_DDK_DRIVER_TEST_INSTALL)
endef

$(eval $(cmake-package))
