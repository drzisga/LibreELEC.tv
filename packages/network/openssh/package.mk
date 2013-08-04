################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="openssh"
PKG_VERSION="6.2p2"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.openssh.com/"
PKG_URL="ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS="zlib openssl"
PKG_BUILD_DEPENDS_TARGET="toolchain zlib openssl"
PKG_PRIORITY="optional"
PKG_SECTION="network"
PKG_SHORTDESC="openssh: An open re-implementation of the SSH package"
PKG_LONGDESC="This is a Linux port of OpenBSD's excellent OpenSSH. OpenSSH is based on the last free version of Tatu Ylonen's SSH with all patent-encumbered algorithms removed, all known security bugs fixed, new features reintroduced, and many other clean-ups. SSH (Secure Shell) is a program to log into another computer over a network, to execute commands in a remote machine, and to move files from one machine to another. It provides strong authentication and secure communications over insecure channels. It is intended as a replacement for rlogin, rsh, rcp, and rdist."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--libexecdir=/usr/lib/openssh \
                           --disable-strip \
                           --disable-lastlog \
                           --with-sandbox=no \
                           --disable-utmp \
                           --disable-utmpx \
                           --disable-wtmp \
                           --disable-wtmpx \
                           --without-rpath \
                           --with-ssl-engine \
                           --without-pam"

pre_configure_target() {
  export LD="$TARGET_CC"
  export LDFLAGS="$TARGET_CFLAGS $TARGET_LDFLAGS"
}

post_makeinstall_target() {
  mkdir -p $INSTALL/etc
    cp $PKG_DIR/config/ssh_config $INSTALL/etc
    cp $PKG_DIR/config/sshd_config $INSTALL/etc

  mkdir -p $INSTALL/usr/sbin
    cp -P $PKG_DIR/scripts/sshd-keygen $INSTALL/usr/sbin

  rm -rf $INSTALL/usr/lib/openssh/ssh-keysign
  rm -rf $INSTALL/usr/lib/openssh/ssh-pkcs11-helper
  if [ ! $SFTP_SERVER = "yes" ]; then
    rm -rf $INSTALL/usr/lib/openssh/sftp-server
  fi
}

post_install() {
  add_user sshd x 74 74 "Privilege-separated SSH" "/var/empty/sshd" "/bin/sh"
  add_group sshd 74

  enable_service sshd.service
#  enable_service sshd.socket
}
