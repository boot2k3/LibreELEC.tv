# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)

PKG_NAME="automake"
PKG_VERSION="1.16.4"
PKG_SHA256="80facc09885a57e6d49d06972c0ae1089c5fa8f4d4c7cfe5baea58e5085f136d"
PKG_LICENSE="GPL"
PKG_SITE="http://sources.redhat.com/automake/"
PKG_URL="http://ftpmirror.gnu.org/automake/${PKG_NAME}-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_HOST="ccache:host autoconf:host"
PKG_LONGDESC="A GNU tool for automatically creating Makefiles."

PKG_CONFIGURE_OPTS_HOST="--target=${TARGET_NAME} --disable-silent-rules"

post_makeinstall_host() {
  make prefix=${SYSROOT_PREFIX}/usr install
}
