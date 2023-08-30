#!/bin/bash
# Brett Kuskie
# fullaxx@gmail.com

set -e

NAME="dddvb"
VERS=`date "+%Y%m%d"`
KVERS=`uname -r`
PKG="${NAME}-${VERS}"
PKGREV=${PKGREV:-rev}
TMP="/tmp/${NAME}-mod-$$"
if [ -e ${TMP} ]; then echo "${TMP} exists, exiting..." >&2; exit 1; fi
if [ `id -u` != "0" ]; then echo "Got Root?"; exit 1; fi

# Automatically determine the architecture we're building on:
if [ -z "${ARCH}" ]; then
  case "$( uname -m )" in
    #i?86) export ARCH=i486 ;;
    arm*) export ARCH=arm ;;
    # Unless ${ARCH} is already set, use uname -m for all other archs:
       *) export ARCH=$( uname -m ) ;;
  esac
fi

git clone https://github.com/DigitalDevices/dddvb.git ${NAME}
pushd ${NAME}

# create the TMP directory, compile the code and install to ${TMP}
make -j
mkdir ${TMP}
make install
find /lib/modules/ -type f -name '*.ko' -cnewer ${TMP} | xargs tar c | tar x -C ${TMP}

# Documentation
mkdir -p ${TMP}/usr/doc/${PKG}
cp README.md CHANGELOG COPYING.GPLv2 ${TMP}/usr/doc/${PKG}/

# back out and copy this script to the module
popd
mkdir -p ${TMP}/usr/src/rlb
cp $0 ${TMP}/usr/src/rlb

# Package up the modules and clean up
dir2xzm ${TMP} 000d-${PKG}-${KVERS}-${ARCH}-${PKGREV}.xzm
rm -rf ${NAME}
rm -rf ${TMP}

# EOF
