################################################################################
#
# ebc_demo
#
################################################################################

EBC_DEMO_SITE = $(TOPDIR)/../app/ebc_demo_pb/rk3566_eink_demo01
EBC_DEMO_SITE_METHOD = local

EBC_DEMO_DEPENDENCIES = rkebc opencv4

EBC_DEMO_INSTALL_STAGING = YES
#EBC_DEMO_SUPPORTS_IN_SOURCE_BUILD = NO

define EBC_DEMO_INSTALL_INIT_SYSV
        $(INSTALL) -m 0755 -D $(TOPDIR)/../app/ebc_demo_pb/rk3566_eink_demo01/S99ebc-demo \
		$(TARGET_DIR)/etc/init.d/S99ebc-demo
endef

$(eval $(cmake-package))

