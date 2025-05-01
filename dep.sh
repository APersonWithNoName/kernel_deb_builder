#!/bin/bash

#echo "deb-src https://deb.debian.org/debian/ bookworm main contrib non-free" >> /etc/apt/sources.list

apt update -y && apt upgrade -y
apt install -y wget xz-utils make gcc flex bison dpkg-dev bc rsync kmod cpio libssl-dev build-essential libelf-dev libncurses5-dev dwarves
#apt build-dep -y linux
