#!/bin/bash

. /etc/os-release
. /lib/functions/uci-defaults.sh

OTA_URL="https://api.kejizero.xyz/openwrt/ota.json"

uci set ota.config.api_url="$OTA_URL"
uci commit ota

uci set argon.@global[0].primary='#31a1a1'
uci commit argon

sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow

sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='ZeroWrt-$(date +%Y%m%d)'/g" /etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By Xiaokailnol'/g" /etc/openwrt_release
sed -i "s|^OPENWRT_RELEASE=\".*\"|OPENWRT_RELEASE=\"ZeroWrt 标准版 @R$(date +%Y%m%d) BY Xiaokailnol\"|" /usr/lib/os-release

exit 0
