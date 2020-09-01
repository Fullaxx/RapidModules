#!/bin/bash

# PKGDIR="/opt/RL/packages/qt5" ./build_qt5.sh 5.13.2

set -e

if [ -z "$1" ]; then
  echo "$0: <version>"
  exit 1
fi

FVERS="$1"
export PKGREV="TEST"

rm -rf /usr/lib64/qt5

./qtbase-${FVERS}.rlb
rl_xm qtbase-${FVERS}-x86_64-${PKGREV}.xzm /

./qttools-${FVERS}.rlb
rl_xm qttools-${FVERS}-x86_64-${PKGREV}.xzm /

./qtmultimedia-${FVERS}.rlb
rl_xm qtmultimedia-${FVERS}-x86_64-${PKGREV}.xzm /

./qtsvg-${FVERS}.rlb
rl_xm qtsvg-${FVERS}-x86_64-${PKGREV}.xzm /

./qtdeclarative-${FVERS}.rlb
rl_xm qtdeclarative-${FVERS}-x86_64-${PKGREV}.xzm /

./qtlocation-${FVERS}.rlb
rl_xm qtlocation-${FVERS}-x86_64-${PKGREV}.xzm /

./qtwebchannel-${FVERS}.rlb
rl_xm qtwebchannel-${FVERS}-x86_64-${PKGREV}.xzm /

./qtwebengine-${FVERS}.rlb
rl_xm qtwebengine-${FVERS}-x86_64-${PKGREV}.xzm /

# ./Py2Qt5-${FVERS}.rlb
./Py3Qt5-${FVERS}.rlb
./qwt-6.1.4-qt5.rlb

TMP="/tmp/QTFIVECOMBINED-${FVERS}-mod-$$"
mkdir ${TMP}
for XZM in *-${FVERS}-x86_64-${PKGREV}.xzm PyQt5-${FVERS}-x86_64-py?-${PKGREV}.xzm qwt-*.xzm; do
  xzm2dir ${XZM} ${TMP}
done

rm -rf *-${FVERS}-x86_64-${PKGREV}.xzm PyQt5-${FVERS}-x86_64-py?-${PKGREV}.xzm qwt-*.xzm
dir2xzm ${TMP} qt5-${FVERS}-x86_64-${PKGREV}.xzm
rm -rf ${TMP}
