#!/bin/bash

. /etc/os-release
. /lib/functions/uci-defaults.sh

OTA_URL="https://api.kejizero.xyz/openwrt/ota.json"

uci set ota.config.api_url="$OTA_URL"
uci commit ota

sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
