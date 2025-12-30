#!/bin/bash

. /etc/os-release
. /lib/functions/uci-defaults.sh

OTA_URL="https://api.kejizero.xyz/openwrt/ota.json"

uci set ota.config.api_url="$OTA_URL"
uci commit ota
