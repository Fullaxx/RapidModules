#!/bin/bash

if [ -z "$1" ]; then
  echo "$0 <country>"
  exit 1
fi

COUNTRY="$1"
DATA="/usr/share/geoip/GeoIPCountryWhois.csv"

grep $COUNTRY $DATA | awk -F, '{print $1 $2}' | tr '"' ' '
