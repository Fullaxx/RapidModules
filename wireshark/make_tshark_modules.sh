#!/bin/bash

rm -rf ws tshark /tmp/ws.tar

set -e

if [ `id -u` != "0" ]; then
  echo "Got Root?"
  exit 1
fi

if [ -z "$1" ]; then
  echo "$0: <WSMOD>"
  exit 2
fi

WSMOD="$1"

if [ ! -r "${WSMOD}" ]; then
  echo "${WSMOD} is not readable!"
  exit 3
fi

TSMOD=`echo "${WSMOD}" | sed -e "s/wire/t/"`

if [ -e "${TSMOD}" ]; then
  echo "${TSMOD} already exists!"
  exit 4
fi

mkdir ws
xzm2dir ${WSMOD} ws

pushd ws
tar cpf /tmp/ws.tar usr/bin/{capinfos,captype,dumpcap,editcap,mergecap,reordercap,tshark} usr/lib64/*.*
popd

mkdir tshark
#pushd tshark
tar xpf /tmp/ws.tar -C tshark
#popd
dir2xzm tshark ${TSMOD}
rm -rf ws tshark /tmp/ws.tar
