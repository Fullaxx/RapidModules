#!/bin/bash
# https://github.com/netdata/netdata/tags
# https://hub.docker.com/r/netdata/netdata/tags

set -e

NAME="netdata"
VERS="1.36.1"
PKG="${NAME}-${VERS}"
TMP="/tmp/${NAME}-mod-$$"
IDIR="${TMP}/usr/share/dimgs/${PKG}"

IMAGE="netdata/netdata"
TAG="v1.36.1"

if [ `id -u` != "0" ]; then echo "Got Root?"; exit 1; fi

# Pull Docker Image
docker pull ${IMAGE}:${TAG}

# Tag Docker Image
docker tag ${IMAGE}:${TAG} ${IMAGE}:latest

# Save Image, Script and Readme
mkdir -p ${IDIR}
docker save ${IMAGE}:latest -o ${IDIR}/${NAME}.tar

wget https://raw.githubusercontent.com/netdata/netdata/master/README.md -O ${IDIR}/README.md

cat << EOFF > ${IDIR}/run.sh
#!/bin/bash

docker load -i netdata.tar
docker run -d \\
--name=netdata \\
-p 1999:19999 \\
-v netdataconfig:/etc/netdata \\
-v netdatalib:/var/lib/netdata \\
-v netdatacache:/var/cache/netdata \\
-v /etc/passwd:/host/etc/passwd:ro \\
-v /etc/group:/host/etc/group:ro \\
-v /proc:/host/proc:ro \\
-v /sys:/host/sys:ro \\
-v /etc/os-release:/host/etc/os-release:ro \\
--restart unless-stopped \\
--cap-add SYS_PTRACE \\
--security-opt apparmor=unconfined \\
netdata/netdata
EOFF
chmod 0700 ${IDIR}/run.sh

# Package Module
dir2xzm ${TMP} ${PKG}.xzm
rm -rf ${PKG}
rm -rf ${TMP}

# EOF
