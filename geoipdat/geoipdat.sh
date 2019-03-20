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

mkdir -p ${TMP}/usr/share/mmdb
wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz -O ${TMP}/usr/share/mmdb/GeoLite2-City.mmdb.gz
wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz -O ${TMP}/usr/share/mmdb/GeoLite2-Country.mmdb.gz
gunzip ${TMP}/usr/share/mmdb/GeoLite2-City.mmdb.gz
gunzip ${TMP}/usr/share/mmdb/GeoLite2-Country.mmdb.gz

# wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City-CSV.zip -O ${TMP}/usr/share/mmdb/GeoLite2-City-CSV.zip
# wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country-CSV.zip -O ${TMP}/usr/share/mmdb/GeoLite2-Country-CSV.zip
# ( set -e; cd ${TMP}/usr/share/mmdb/; unzip GeoLite2-City-CSV.zip; rm GeoLite2-City-CSV.zip )
# ( set -e; cd ${TMP}/usr/share/mmdb/; unzip GeoLite2-Country-CSV.zip; rm GeoLite2-Country-CSV.zip )

# Package up the modules and clean up
dir2xzm ${TMP} ${PKG}-noarch-${PKGREV}.xzm
rm -rf ${PKG}
rm -rf ${TMP}

# EOF
