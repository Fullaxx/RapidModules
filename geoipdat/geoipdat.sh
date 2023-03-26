#!/bin/bash
# Brett Kuskie
# fullaxx@gmail.com

set -e

NAME="geoipdat"
VERS=`date "+%y%m%d"`
PKG="${NAME}-${VERS}"
PKGREV=${PKGREV:-rev}
TMP="/tmp/${NAME}-mod-$$"
if [ -e ${TMP} ]; then echo "${TMP} exists, exiting..." >&2; exit 1; fi

EXDIR=`mktemp -d`
mkdir -p ${TMP}/usr/share/mmdb

for ZIP in *.zip; do
  unzip ${ZIP} -d ${EXDIR}
done

for TAR in *.tar.gz; do
  tar xf ${TAR} -C ${EXDIR}
done

LFILE=`ls -1 ${EXDIR}/*/LICENSE.txt | head -n1`
CFILE=`ls -1 ${EXDIR}/*/COPYRIGHT.txt | head -n1`
rm -- ${EXDIR}/*/*-Locations-{de,es,fr,ja,pt-BR,ru,zh-CN}.csv
cp -av ${LFILE} ${CFILE} ${TMP}/usr/share/mmdb/
cp -av ${EXDIR}/*/*.{csv,mmdb} ${TMP}/usr/share/mmdb/
rm -rf ${EXDIR}

# Package up the modules and clean up
dir2xzm ${TMP} ${PKG}-noarch-${PKGREV}.xzm
rm -rf ${PKG}
rm -rf ${TMP}

# EOF
