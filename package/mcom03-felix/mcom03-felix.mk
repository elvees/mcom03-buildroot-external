################################################################################
#
# mcom03-felix
#
################################################################################

# Force build from sources if override srcdir is enabled
ifneq ($(MCOM03_FELIX_OVERRIDE_SRCDIR),)
MCOM03_FELIX_INSTALL_SRC = y
MCOM03_FELIX_GIT_DIR = $(MCOM03_FELIX_OVERRIDE_SRCDIR)
else
MCOM03_FELIX_INSTALL_SRC = $(BR2_PACKAGE_MCOM03_FELIX_INSTALL_SRC)
MCOM03_FELIX_GIT_DIR = $(MCOM03_FELIX_DL_DIR)/git
endif

MCOM03_FELIX_DEPENDENCIES = linux sensor-phy

MCOM03_FELIX_LINUX_ID = $(call qstrip,$(BR2_PACKAGE_MCOM03_FELIX_LINUX_VERSION))
ifeq ($(BR2_PACKAGE_MCOM03_FELIX)$(BR_BUILDING),yy)
ifeq ($(MCOM03_FELIX_LINUX_ID),)
$(error Linux version for Felix not specified. Check your BR2_PACKAGE_MCOM03_FELIX_LINUX_VERSION setting)
endif
endif

# Installation from source code
ifeq ($(MCOM03_FELIX_INSTALL_SRC),y)
MCOM03_FELIX_VERSION = master
MCOM03_FELIX_SITE_METHOD = git
MCOM03_FELIX_SITE = ssh://gerrit.elvees.com:29418/mcom03/felix
MCOM03_FELIX_SUBDIR = DDKSource

MCOM03_FELIX_INSTALL_LOCAL = $(@D)/install
MCOM03_FELIX_INSTALL_BIN = $(TARGET_DIR)/usr/bin
MCOM03_FELIX_INSTALL_MOD =  $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)
MCOM03_FELIX_INSTALL_CONFIG = $(TARGET_DIR)/usr/share/isp/data
MCOM03_FELIX_INSTALL_IMAGES = YES

MCOM03_FELIX_TARGET_FILES = $(MCOM03_FELIX_INSTALL_MOD)/extra/Felix.ko

# 1 => enable driver debug functions
MCOM03_FELIX_CI_DEBUG_FUNCTIONS=1
# 0 => internal data generator; 1 => external data generator
MCOM03_FELIX_CI_EXT_DATA_GENERATOR=0

MCOM03_FELIX_BOARDCFG_DIR = /etc/felix/boardcfg

MCOM03_FELIX_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
MCOM03_FELIX_CONF_OPTS += -DCMAKE_INSTALL_PREFIX=$(MCOM03_FELIX_INSTALL_LOCAL)

MCOM03_FELIX_CONF_OPTS += -DLINUX_KERNEL_ARCH="ARCH=$(KERNEL_ARCH)"
MCOM03_FELIX_CONF_OPTS += -DLINUX_KERNEL_CROSS_COMPILE="CROSS_COMPILE=$(TARGET_CROSS)"
MCOM03_FELIX_CONF_OPTS += -DLINUX_KERNEL_BUILD_DIR=$(LINUX_DIR)

MCOM03_FELIX_CONF_OPTS += -DBUILD_SCB_DRIVER=OFF
MCOM03_FELIX_CONF_OPTS += -DBUILD_UNIT_TESTS=OFF
MCOM03_FELIX_CONF_OPTS += -DCI_ALLOC=PAGEALLOC
MCOM03_FELIX_CONF_OPTS += -DCI_BUILD_KERNEL_MODULE=ON
MCOM03_FELIX_CONF_OPTS += -DCI_DEBUG_FUNCTIONS=$(MCOM03_FELIX_CI_DEBUG_FUNCTIONS)
MCOM03_FELIX_CONF_OPTS += -DCI_DEVICE=DEVICE_TREE
MCOM03_FELIX_CONF_OPTS += -DCI_EXT_DATA_GENERATOR=$(MCOM03_FELIX_CI_EXT_DATA_GENERATOR)
MCOM03_FELIX_CONF_OPTS += -DFELIX_PDP=OFF
MCOM03_FELIX_CONF_OPTS += -DSENSORAPI_EUROPA=1
MCOM03_FELIX_CONF_OPTS += -DSENSORAPI_BOARDCFG_DIR=$(MCOM03_FELIX_BOARDCFG_DIR)

MCOM03_FELIX_CONF_OPTS += -DIMG_SCB_POLLING_MODE=1
MCOM03_FELIX_CONF_OPTS += -DBUILDS_TEST_APPS=1

ifeq ($(BR2_PACKAGE_MCOM03_DMABUF_EXPORTER),y)
MCOM03_FELIX_CONF_OPTS += -DUSE_DMABUF_EXPORTER=1
MCOM03_FELIX_DEPENDENCIES += mcom03-dmabuf-exporter
else
MCOM03_FELIX_CONF_OPTS += -DUSE_DMABUF_EXPORTER=0
endif

ifeq ($(BR2_PACKAGE_MCOM03_FELIX_SENSOR_PARAXDMA_LINUX),y)
MCOM03_FELIX_CONF_OPTS += -DSENSOR_PARAXDMA_LINUX=1
MCOM03_FELIX_TARGET_FILES += $(addprefix $(MCOM03_FELIX_INSTALL_CONFIG)/paraxdma/,$(notdir $(wildcard $(@D)/haps-tests/setup-args-para*.txt)))
define MCOM03_FELIX_SENSOR_PARAXDMA_CONFIG_INSTALL
	mkdir -p $(MCOM03_FELIX_INSTALL_CONFIG)/paraxdma
	$(INSTALL) -D -m 0644 $(@D)/haps-tests/setup-args-para*.txt $(MCOM03_FELIX_INSTALL_CONFIG)/paraxdma
endef
endif

ifeq ($(BR2_PACKAGE_MCOM03_FELIX_ISPC_TEST),y)
MCOM03_FELIX_TARGET_FILES += $(MCOM03_FELIX_INSTALL_BIN)/felix-ispc-test
define MCOM03_FELIX_ISPC_TEST_INSTALL
	$(INSTALL) -D -m 0755 $(MCOM03_FELIX_INSTALL_LOCAL)/ISPC/felix-ispc-test $(MCOM03_FELIX_INSTALL_BIN)/felix-ispc-test
endef
endif

ifeq ($(BR2_PACKAGE_MCOM03_FELIX_ISPC_LOOP),y)
ifeq ($(BR2_PACKAGE_LIBDRM),y)
MCOM03_FELIX_CONF_OPTS += -DCI_PDP_DMABUF=1
endif
MCOM03_FELIX_TARGET_FILES += $(MCOM03_FELIX_INSTALL_BIN)/felix-ispc-loop
define MCOM03_FELIX_ISPC_LOOP_INSTALL
	$(INSTALL) -D -m 0755 $(MCOM03_FELIX_INSTALL_LOCAL)/ISPC/felix-ispc-loop $(MCOM03_FELIX_INSTALL_BIN)/felix-ispc-loop
endef
endif

ifeq ($(BR2_PACKAGE_MCOM03_FELIX_DRIVER_TEST),y)
MCOM03_FELIX_TARGET_FILES += $(MCOM03_FELIX_INSTALL_BIN)/felix-driver-test
define MCOM03_FELIX_DRIVER_TEST_INSTALL
	$(INSTALL) -D -m 0755 $(MCOM03_FELIX_INSTALL_LOCAL)/CI/felix-driver-test $(MCOM03_FELIX_INSTALL_BIN)/felix-driver-test
endef
endif

ifeq ($(BR2_PACKAGE_MCOM03_FELIX_SENSOR_TEST),y)
MCOM03_FELIX_TARGET_FILES += $(MCOM03_FELIX_INSTALL_BIN)/felix-sensor-test
define MCOM03_FELIX_SENSOR_TEST_INSTALL
	$(INSTALL) -D -m 0755 $(MCOM03_FELIX_INSTALL_LOCAL)/bin/felix-sensor-test $(MCOM03_FELIX_INSTALL_BIN)/felix-sensor-test
endef
endif
ifeq ($(BR2_PACKAGE_MCOM03_FELIX_I2C_TEST),y)
MCOM03_FELIX_TARGET_FILES += $(MCOM03_FELIX_INSTALL_BIN)/felix-i2c-test
define MCOM03_FELIX_I2C_TEST_INSTALL
	$(INSTALL) -D -m 0755 $(MCOM03_FELIX_INSTALL_LOCAL)/bin/felix-i2c-test $(MCOM03_FELIX_INSTALL_BIN)/felix-i2c-test
endef
endif
ifeq ($(BR2_PACKAGE_MCOM03_FELIX_FOCUS_TEST),y)
MCOM03_FELIX_TARGET_FILES += $(MCOM03_FELIX_INSTALL_BIN)/felix-focus-test
define MCOM03_FELIX_FOCUS_TEST_INSTALL
	$(INSTALL) -D -m 0755 $(MCOM03_FELIX_INSTALL_LOCAL)/bin/felix-focus-test $(MCOM03_FELIX_INSTALL_BIN)/felix-focus-test
endef
endif
ifeq ($(BR2_PACKAGE_MCOM03_FELIX_SENSOR_MODES),y)
MCOM03_FELIX_TARGET_FILES += $(MCOM03_FELIX_INSTALL_BIN)/felix-sensor-modes
define MCOM03_FELIX_SENSOR_MODES_INSTALL
	$(INSTALL) -D -m 0755 $(MCOM03_FELIX_INSTALL_LOCAL)/bin/felix-sensor-modes $(MCOM03_FELIX_INSTALL_BIN)/felix-sensor-modes
endef
endif

ifeq ($(BR2_PACKAGE_MCOM03_FELIX_SENSOR_OV2718),y)
MCOM03_FELIX_CONF_OPTS += -DSENSOR_OV2718=1
else
MCOM03_FELIX_CONF_OPTS += -DSENSOR_OV2718=0
endif

ifeq ($(BR2_PACKAGE_MCOM03_FELIX_SENSOR_OV4689),y)
MCOM03_FELIX_CONF_OPTS += -DSENSOR_OV4689=1
else
MCOM03_FELIX_CONF_OPTS += -DSENSOR_OV4689=0
endif

ifeq ($(BR2_PACKAGE_MCOM03_FELIX_SENSOR_OV5647),y)
MCOM03_FELIX_CONF_OPTS += -DSENSOR_OV5647=1
else
MCOM03_FELIX_CONF_OPTS += -DSENSOR_OV5647=0
endif

ifeq ($(BR2_PACKAGE_MCOM03_FELIX_SENSOR_OV10823),y)
MCOM03_FELIX_CONF_OPTS += -DSENSOR_OV10823=1
else
MCOM03_FELIX_CONF_OPTS += -DSENSOR_OV10823=0
endif

MCOM03_FELIX_TARGET_FILES += $(TARGET_DIR)/etc/felix
define MCOM03_FELIX_SENSORCFG_INSTALL
	set -e; \
	mkdir -p $(TARGET_DIR)/etc/felix; \
	if [ -d $(MCOM03_FELIX_INSTALL_LOCAL)/sensorcfg ]; then \
		cp -rf $(MCOM03_FELIX_INSTALL_LOCAL)/sensorcfg/* $(TARGET_DIR)/etc/felix; \
	fi
endef

define MCOM03_FELIX_BOARDCFG_INSTALL
	set -e; \
	mkdir -p $(TARGET_DIR)$(MCOM03_FELIX_BOARDCFG_DIR); \
	cp -rf $(@D)/DDKSource/boardcfg/* $(TARGET_DIR)$(MCOM03_FELIX_BOARDCFG_DIR);
endef

define MCOM03_FELIX_INSTALL_TARGET_CMDS
	make -C $(@D)/$(MCOM03_FELIX_SUBDIR) install
	$(INSTALL) -D -m 0644 $(MCOM03_FELIX_INSTALL_LOCAL)/km/Felix.ko $(MCOM03_FELIX_INSTALL_MOD)/extra/Felix.ko
	depmod -b $(TARGET_DIR) $(LINUX_VERSION_PROBED)
	$(MCOM03_FELIX_SENSOR_PARAXDMA_CONFIG_INSTALL)
	$(MCOM03_FELIX_ISPC_TEST_INSTALL)
	$(MCOM03_FELIX_ISPC_LOOP_INSTALL)
	$(MCOM03_FELIX_DRIVER_TEST_INSTALL)
	$(MCOM03_FELIX_SENSOR_TEST_INSTALL)
	$(MCOM03_FELIX_I2C_TEST_INSTALL)
	$(MCOM03_FELIX_FOCUS_TEST_INSTALL)
	$(MCOM03_FELIX_SENSOR_MODES_INSTALL)
	$(MCOM03_FELIX_SENSORCFG_INSTALL)
	$(MCOM03_FELIX_BOARDCFG_INSTALL)
endef

MCOM03_FELIX_BIN_VERSION = $(shell date +%Y%m%d)-$(shell git -C $(MCOM03_FELIX_GIT_DIR) describe --always || echo "unknown")

# Create tarball with binaries
define MCOM03_FELIX_INSTALL_IMAGES_CMDS
	tar -C $(TARGET_DIR) -czf \
		$(BINARIES_DIR)/mcom03-felix-$(MCOM03_FELIX_LINUX_ID)-$(MCOM03_FELIX_BIN_VERSION).tar.gz \
		$(MCOM03_FELIX_TARGET_FILES:$(TARGET_DIR)/%=%)
endef

$(eval $(cmake-package))

# Installation from tarball with binaries
else
MCOM03_FELIX_VERSION = $(MCOM03_FELIX_LINUX_ID)-latest
MCOM03_FELIX_SITE = $(BR2_ELVEES_BINARY_PACKAGES_SITE)/mcom03-felix
MCOM03_FELIX_STRIP_COMPONENTS = 0

define MCOM03_FELIX_INSTALL_TARGET_CMDS
	rsync -aK $(@D)/* $(TARGET_DIR)
endef

$(eval $(generic-package))

endif
