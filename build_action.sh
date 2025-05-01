#!/usr/bin/env bash

VERSION=6.1.114

# add deb-src to sources.list
#sed -i "/deb-src/s/# //g" /etc/apt/sources.list

# change dir to workplace
cd "${GITHUB_WORKSPACE}" || exit

# download kernel source
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-${VERSION}.tar.gz
tar -xvf linux-${VERSION}.tar.gz
rm -rf linux-${VERSION}.tar.gz
cd linux-${VERSION} || exit

# copy config file
cp ../config .config

# disable DEBUG_INFO to speedup build
scripts/config --disable DEBUG_INFO

# apply patches
# shellcheck source=src/util.sh
#source ../patch.d/*.sh

# build kernel
CPU_CORES=$(($(grep -c processor < /proc/cpuinfo)*2))
make  -j"$CPU_CORES"

# set install dir
mkdir /tmp/kernel/linux_kernel-${VERSION}-x86_64
export INSTALL_PATH=/tmp/kernel/linux_kernel-${VERSION}-x86_64
mkdir /tmp/kernel/linux_modules-${VERSION}-x86_64
export INSTALL_MOD_PATH=/tmp/kernel/linux_modules-${VERSION}-x86_64

# make tar archive
make install
tar -cvf ../linux_kernel-${VERSION}-x86_64.tar.gz ${INSTALL_PATH}
tar -cvf ../linux_modules-${VERSION}-x86_64.tar.gz ${INSTALL_MOD_PATH}

# make deb package
make deb-pkg

# move deb packages to artifact dir
cd ..
rm -rfv *dbg*.deb
mkdir "artifact"
mv ../linux_kernel-${VERSION}-x86_64.tar.gz artifact/
mv ../linux_modules-${VERSION}-x86_64.tar.gz artifact/
mv ./*.deb artifact/
