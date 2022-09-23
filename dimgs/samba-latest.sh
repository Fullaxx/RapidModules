#!/bin/bash
# https://github.com/dperson/samba
# https://hub.docker.com/r/dperson/samba

set -e

NAME="samba"
VERS=`date "+%y%m%d"`
PKG="${NAME}-${VERS}"
TMP="/tmp/${NAME}-mod-$$"
IDIR="${TMP}/usr/share/dimgs/${PKG}"

IMAGE="dperson/samba"
TAG="latest"

if [ `id -u` != "0" ]; then echo "Got Root?"; exit 1; fi

# Pull Docker Image
docker pull ${IMAGE}:${TAG}

# Tag Docker Image
docker tag ${IMAGE}:${TAG} ${IMAGE}:latest

# Save Image, Script and Readme
mkdir -p ${IDIR}
docker save ${IMAGE}:latest -o ${IDIR}/${NAME}.tar

wget https://raw.githubusercontent.com/dperson/samba/master/README.md -O ${IDIR}/README.md

cat << EOFF > ${IDIR}/run.sh
#!/bin/bash

docker load -i samba.tar
docker run -d \\
-p 139:139 \\
-p 445:445 \\
dperson/samba -p \\
-u "example1;badpass" \\
-u "example2;badpass" \\
-s "public;/share" \\
-s "users;/srv;no;no;no;example1,example2" \\
-s "example1 private share;/example1;no;no;no;example1" \\
-s "example2 private share;/example2;no;no;no;example2"

EOFF
chmod 0700 ${IDIR}/run.sh

# Package Module
dir2xzm ${TMP} ${PKG}.xzm
rm -rf ${PKG}
rm -rf ${TMP}

# EOF
