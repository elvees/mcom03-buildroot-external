################################################################################
#
# mcom03-linux-utils-python
#
################################################################################

MCOM03_LINUX_UTILS_PYTHON_VERSION = master
MCOM03_LINUX_UTILS_PYTHON_SITE = ssh://gerrit.elvees.com:29418/mcom03/linux-utils.git
MCOM03_LINUX_UTILS_PYTHON_SITE_METHOD = git
MCOM03_LINUX_UTILS_PYTHON_LICENSE = MIT
MCOM03_LINUX_UTILS_PYTHON_SETUP_TYPE = setuptools

$(eval $(python-package))
