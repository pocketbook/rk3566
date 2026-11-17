################################################################################
#
# glmark2
#
################################################################################

GLMARK2_SITE = $(TOPDIR)/../app/glmark2
GLMARK2_SITE_METHOD = local
GLMARK2_INSTALL_STAGING = YES
GLMARK2_INSTALL_TARGET = YES
GLMARK2_LICENSE = GPL-3.0+, SGIv1
GLMARK2_LICENSE_FILES = COPYING COPYING.SGI
GLMARK2_DEPENDENCIES = host-pkgconf jpeg libegl libpng
GLMARK2_DEPENDENCIES += libdrm libgbm libgles
GLMARK2_FLAVORS = drm-glesv2
#GLMARK2_FLAVORS += null-glesv2
GLMARK2_VERSION=custom

GLMARK2_CONF_OPTS = -Dflavors=$(subst $(space),$(comma),$(GLMARK2_FLAVORS))

$(eval $(meson-package))
