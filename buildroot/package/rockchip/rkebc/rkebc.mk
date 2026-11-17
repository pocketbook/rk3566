################################################################################
#
# rkebc project
#
################################################################################

RKEBC_VERSION = 0.9.7
RKEBC_SITE = $(TOPDIR)/../external/rkebc
RKEBC_SITE_METHOD = local
#RKEBC_SITE = $(TOPDIR)/package/rockchip/rkebc
#RKEBC_SITE_METHOD = file
#RKEBC_SOURCE = rkebc-$(RKEBC_VERSION).tgz

RKEBC_LICENSE = Apache-2.0
RKEBC_LICENSE_FILES = COPYING
RKEBC_REDISTRIBUTE = NO

RKEBC_INSTALL_STAGING = YES

RKEBC_DEPENDENCIES = rockchip-rga lz4 inih zlib

ifeq ($(call qstrip,$(BR2_ARCH)), arm)
ARCH = arm
else ifeq ($(call qstrip, $(BR2_ARCH)), aarch64)
ARCH = aarch64
endif

define RKEBC_PRE_CONFIGURE_HOOK
        mkdir -p $(STAGING_DIR)/usr/include/rkebc
        $(INSTALL) -D -m 0644 $(@D)/include/rkebc_api.h $(STAGING_DIR)/usr/include/rkebc/
        $(INSTALL) -D -m 0644 $(@D)/include/rkebc_client.h $(STAGING_DIR)/usr/include/rkebc/
        $(INSTALL) -D -m 0644 $(@D)/include/ebc_uapi.h $(STAGING_DIR)/usr/include/rkebc/
        $(INSTALL) -D -m 0644 $(@D)/include/etrace.h $(STAGING_DIR)/usr/include/rkebc/

	$(INSTALL) -D -m 0644 $(@D)/rkcfa/include/rkcfa_api.h $(STAGING_DIR)/usr/include/
endef
RKEBC_PRE_CONFIGURE_HOOKS += RKEBC_PRE_CONFIGURE_HOOK

#define RKEBC_INSTALL_TARGET_ENV
#        $(INSTALL) -D -m 0644 $(RKEBC_PKGDIR)/rkebc.sh \
#                $(TARGET_DIR)/etc/profile.d/rkebc.sh
#endef
#RKEBC_POST_INSTALL_TARGET_HOOKS += RKEBC_INSTALL_TARGET_ENV

define RKEBC_INSTALL_INIT_SYSV
        $(INSTALL) -D -m 755 $(@D)/S02rkebc \
                $(TARGET_DIR)/etc/init.d/S02rkebc
        $(INSTALL) -D -m 755 $(@D)/01eink \
                $(TARGET_DIR)/etc/pm/sleep.d/01eink
endef

$(eval $(cmake-package))
