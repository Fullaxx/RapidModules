#!/bin/bash
# https://github.com/dperson/samba
# https://hub.docker.com/r/dperson/samba

set -e

NAME="dockly"
VERS=`date "+%y%m%d"`
PKG="${NAME}-${VERS}"
TMP="/tmp/${NAME}-mod-$$"
IDIR="${TMP}/usr/share/dimgs/${PKG}"

IMAGE="lirantal/dockly"
TAG="latest"

if [ `id -u` != "0" ]; then echo "Got Root?"; exit 1; fi

# Pull Docker Image
docker pull ${IMAGE}:${TAG}

# Tag Docker Image
docker tag ${IMAGE}:${TAG} ${IMAGE}:latest

# Save Image, Script and Readme
mkdir -p ${IDIR}
docker save ${IMAGE}:latest -o ${IDIR}/${NAME}.tar

wget https://raw.githubusercontent.com/lirantal/dockly/main/README.md -O ${IDIR}/README.md

cat << EOFF > ${IDIR}/run.sh
#!/bin/bash

docker load -i dockly.tar

docker run -it --rm \\
-v /var/run/docker.sock:/var/run/docker.sock \\
lirantal/dockly

EOFF
chmod 0700 ${IDIR}/run.sh

# Package Module
dir2xzm ${TMP} ${PKG}.xzm
rm -rf ${PKG}
rm -rf ${TMP}

# EOF
