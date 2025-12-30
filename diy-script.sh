#!/bin/bash

# 修改默认IP
sed -i 's/192.168.100.1/10.0.0.1/g' package/istoreos-files/Makefile

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 移除要替换的包
rm -rf feeds/packages/lang/golang
rm -rf package/diy/luci-app-ota
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}

# Go 26.x
git clone --depth=1 -b 26.x https://"$GIT_NAME":"$GIT_PASSWORD"@gitea.kejizero.xyz/zhao/packages_lang_golang feeds/packages/lang/golang

# 添加额外插件
git clone --depth=1 -b v5 https://github.com/sbwml/luci-app-mosdns package/new/luci-app-mosdns
git clone --depth=1 -b main https://github.com/sbwml/luci-app-openlist2 package/new/openlist
git clone --depth=1 -b main https://github.com/sirpdboy/luci-app-adguardhome package/new/luci-app-adguardhome
git clone --depth=1 -b master https://"$GIT_NAME":"$GIT_PASSWORD"@gitea.kejizero.xyz/zhao/luci-app-ota package/new/luci-app-ota

# 科学上网插件
git clone --depth=1 -b master https://"$GIT_NAME":"$GIT_PASSWORD"@gitea.kejizero.xyz/zhao/openwrt_helloworld package/new/openwrt_helloworld

# 更改 Argon 主题背景
cp -f $GITHUB_WORKSPACE/images/bg1.jpg feeds/third/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 修复 Rust 错误
sed -i 's/--set=llvm\.download-ci-llvm=true \\/--set=llvm.download-ci-llvm=false \\/' feeds/packages/lang/rust/Makefile

# 修正内核值
curl -L -O https://downloads.openwrt.org/releases/24.10.4/targets/rockchip/armv8/profiles.json
jq -r '.linux_kernel.vermagic' profiles.json >.vermagic
sed -i -e 's/^\(.\).*vermagic$/\1cp $(TOPDIR)\/.vermagic $(LINUX_DIR)\/.vermagic/' include/kernel-defaults.mk

# OTA 在线更新
sed -i "/BUILD_DATE/d" package/base-files/files/usr/lib/os-release
sed -i "/BUILD_ID/aBUILD_DATE=\"$CURRENT_DATE\"" package/base-files/files/usr/lib/os-release
