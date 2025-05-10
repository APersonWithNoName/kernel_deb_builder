#!/usr/bin/env bash

VERSION=2.40

# add deb-src to sources.list
#sed -i "/deb-src/s/# //g" /etc/apt/sources.list

# change dir to workplace
cd "${GITHUB_WORKSPACE}" || exit
#install deps
apt install build-dep util-linux
# download kernel source
https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v${VERSION}/util-linux-${VERSION}.tar.gz
tar -xvf util-linux-${VERSION}.tar.gz
cd util-linux-${VERSION}
# copy config file
mkdir _install
./configure --prefix=./_install --enable-tunelp --enable-line --enable-vipw --enable-newgrp --enable-chfn-chsh --enable-pg --enable-write --enable-login-stat-mail --enable-login-chown-vcs --disable-chfn-chsh-password --enable-libmount-support-mtab --without-python --disable-raw

# apply patches
# shellcheck source=src/util.sh
#source ../patch.d/*.sh

# build 
CPU_CORES=$(($(grep -c processor < /proc/cpuinfo)*2))
make  -j"$CPU_CORES"

# set install dir

# make tar archive
make install
tar -cvf ../util-linux-${VERSION}-build-x86_64.tar.gz ./_install
# make deb package

# move deb packages to artifact dir
cd ..
mkdir "artifact"
mv  ../util-linux-${VERSION}-build-x86_64.tar.gz artifact/
