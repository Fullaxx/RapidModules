#!/bin/bash

PKGDIR=${PKGDIR:-/opt/RL/packages/chrome}

if [ -e google-chrome-stable_current_amd64.deb ]; then rm google-chrome-stable_current_amd64.deb; fi
LATESTDEB=`ls -1 ${PKGDIR}/google-chrome-*-amd64.deb | sort -rn | head -n1`
ln -s ${LATESTDEB} google-chrome-stable_current_amd64.deb
