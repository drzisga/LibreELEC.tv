# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="RTL88x2BU"
PKG_VERSION="d53b283012a58acf2c3a119cd11083ff4d8f2ff4"
PKG_SHA256="3aea4485f27f52c56cc4e6867c3aee574fafec804b7fe6e6988c992bd976d95c"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/RinCat/RTL88x2BU-Linux-Driver"
PKG_URL="https://github.com/RinCat/RTL88x2BU-Linux-Driver/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_LONGDESC="Realtek RTL88x2BU Linux driver"
PKG_IS_KERNEL_PKG="yes"

pre_make_target() {
  unset LDFLAGS
}

make_target() {
  make V=1 \
       ARCH=$TARGET_KERNEL_ARCH \
       KSRC=$(kernel_path) \
       CROSS_COMPILE=$TARGET_KERNEL_PREFIX \
       CONFIG_POWER_SAVING=n
}

makeinstall_target() {
  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
    cp *.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME
}