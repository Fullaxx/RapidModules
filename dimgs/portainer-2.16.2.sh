#!/bin/bash
# https://github.com/netdata/netdata/tags
# https://hub.docker.com/r/netdata/netdata/tags

set -e

NAME="portainer"
VERS="2.16.2"
PKG="${NAME}-${VERS}"
TMP="/tmp/${NAME}-mod-$$"
IDIR="${TMP}/usr/share/dimgs/${PKG}"

IMAGE="portainer/portainer-ce"
TAG="${VERS}"

if [ `id -u` != "0" ]; then echo "Got Root?"; exit 1; fi

# Pull Docker Image
docker pull ${IMAGE}:${TAG}

# Tag Docker Image
docker tag ${IMAGE}:${TAG} ${IMAGE}:latest

# Save Image, Script and Readme
mkdir -p ${IDIR}
docker save ${IMAGE}:latest -o ${IDIR}/${NAME}.tar

# wget https://raw.githubusercontent.com/netdata/netdata/master/README.md -O ${IDIR}/README.md

cat << EOFF > ${IDIR}/run.sh
#!/bin/bash

docker load -i portainer.tar
docker run -d \\
--ulimit 1048576:1048576 \\
--name=portainer \\
--restart=always \\
-p 8000:8000 \\
-p 9443:9443 \\
-v /var/run/docker.sock:/var/run/docker.sock \\
-v portainer_data:/data \\
portainer/portainer-ce:latest
EOFF
chmod 0700 ${IDIR}/run.sh

# Package Module
dir2xzm ${TMP} ${PKG}.xzm
rm -rf ${PKG}
rm -rf ${TMP}

# EOF
