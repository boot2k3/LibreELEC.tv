# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xf86-video-nvidia"
# Remember to run "python3 packages/x11/driver/xf86-video-nvidia/scripts/make_nvidia_udev.py" and commit changes to
# "packages/x11/driver/xf86-video-nvidia/udev.d/96-nvidia.rules" whenever bumping version.
# Host may require installation of python3-lxml and python3-requests packages.
PKG_VERSION="460.91.03"
PKG_SHA256="448156cfcef182ed6997c2754c472fd681bf7139b821d2adce1d847220c6c933"
PKG_ARCH="x86_64"
PKG_LICENSE="nonfree"
PKG_SITE="http://www.nvidia.com/"
PKG_URL="http://us.download.nvidia.com/XFree86/Linux-x86_64/${PKG_VERSION}/NVIDIA-Linux-x86_64-${PKG_VERSION}-no-compat32.run"
PKG_DEPENDS_TARGET="util-macros xorg-server libvdpau libglvnd"
PKG_LONGDESC="The Xorg driver for NVIDIA video chips."
PKG_TOOLCHAIN="manual"

PKG_IS_KERNEL_PKG="yes"

unpack() {
  [ -d ${PKG_BUILD} ] && rm -rf ${PKG_BUILD}

  sh ${SOURCES}/${PKG_NAME}/${PKG_SOURCE_NAME} --extract-only --target ${PKG_BUILD}
}

make_target() {
  unset LDFLAGS

  cd kernel
    make module CC=${CC} LD=${LD} SYSSRC=$(kernel_path) SYSOUT=$(kernel_path)
    ${STRIP} --strip-debug nvidia.ko
  cd ..
}

makeinstall_target() {
  mkdir -p ${INSTALL}/${XORG_PATH_MODULES}/drivers
    cp -P nvidia_drv.so ${INSTALL}/${XORG_PATH_MODULES}/drivers/nvidia-main_drv.so
    ln -sf /var/lib/nvidia_drv.so ${INSTALL}/${XORG_PATH_MODULES}/drivers/nvidia_drv.so

  mkdir -p ${INSTALL}/${XORG_PATH_MODULES}/extensions
  # rename to avoid conflicts with X.Org-Server module libglx.so 
    cp -P libglxserver_nvidia.so.${PKG_VERSION} ${INSTALL}/${XORG_PATH_MODULES}/extensions/libglx_nvidia.so

  mkdir -p ${INSTALL}/etc/X11
    cp ${PKG_DIR}/config/*.conf ${INSTALL}/etc/X11

  mkdir -p ${INSTALL}/usr/lib
    cp -P libnvidia-glcore.so.${PKG_VERSION} ${INSTALL}/usr/lib
    cp -P libnvidia-ml.so.${PKG_VERSION} ${INSTALL}/usr/lib
    ln -sf /var/lib/libnvidia-ml.so.1 ${INSTALL}/usr/lib/libnvidia-ml.so.1
    cp -P libnvidia-tls.so.${PKG_VERSION} ${INSTALL}/usr/lib
    cp -P libGLX_nvidia.so.${PKG_VERSION} ${INSTALL}/usr/lib/libGLX_nvidia.so.0

  mkdir -p ${INSTALL}/$(get_full_module_dir)/nvidia
    ln -sf /var/lib/nvidia.ko ${INSTALL}/$(get_full_module_dir)/nvidia/nvidia.ko
    cp -P kernel/nvidia-uvm.ko ${INSTALL}/$(get_full_module_dir)/nvidia
    cp -P kernel/nvidia-modeset.ko ${INSTALL}/$(get_full_module_dir)/nvidia

  mkdir -p ${INSTALL}/usr/lib/nvidia
    cp -P kernel/nvidia.ko ${INSTALL}/usr/lib/nvidia

  mkdir -p ${INSTALL}/usr/bin
    ln -s /var/lib/nvidia-smi ${INSTALL}/usr/bin/nvidia-smi
    cp nvidia-smi ${INSTALL}/usr/bin/nvidia-main-smi
    ln -s /var/lib/nvidia-xconfig ${INSTALL}/usr/bin/nvidia-xconfig
    cp nvidia-xconfig ${INSTALL}/usr/bin/nvidia-main-xconfig

  mkdir -p ${INSTALL}/usr/lib/vdpau
    cp libvdpau_nvidia.so* ${INSTALL}/usr/lib/vdpau/libvdpau_nvidia-main.so.1
    ln -sf /var/lib/libvdpau_nvidia.so ${INSTALL}/usr/lib/vdpau/libvdpau_nvidia.so
    ln -sf /var/lib/libvdpau_nvidia.so.1 ${INSTALL}/usr/lib/vdpau/libvdpau_nvidia.so.1
}
