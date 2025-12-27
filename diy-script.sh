#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/istoreos-files/Makefile

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# 移除要替换的包
rm -rf feeds/packages/lang/golang
rm -rf package/diy/luci-app-ota
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box}

# Go 26.x
git clone --depth=1 -b 26.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# 科学上网插件
git clone --depth=1 -b v5 https://github.com/sbwml/openwrt_helloworld package/helloworld

# 修复 Rust 错误
sed -i 's/--set=llvm\.download-ci-llvm=true \\/--set=llvm.download-ci-llvm=false \\/' feeds/packages/lang/rust/Makefile
