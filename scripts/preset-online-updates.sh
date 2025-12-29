#!/bin/bash

# 设置错误处理：任何命令失败则退出脚本
set -e

# 定义变量
BUILD_DATE=$(date +%s)
OTA_DIR="ota"
OTA_BASE_URL="https://github.com/Xiaokailnol/istoreos-actions-builder/releases/download"
IMG_PATTERN="bin/targets/rockchip/armv8*/*-squashfs-sysupgrade.img.gz"
JSON_FILE="${OTA_DIR}/rockchip.json"

# 计算 SHA256（精确匹配一个文件）
IMG_FILE=$(ls ${IMG_PATTERN} 2>/dev/null | head -1)
if [[ -z "$IMG_FILE" ]]; then
    echo "错误：未找到匹配的镜像文件" >&2
    exit 1
fi
SHA256=$(sha256sum "$IMG_FILE" | awk '{print $1}')

# 创建输出目录
mkdir -p "$OTA_DIR"

# 生成 JSON 文件
cat > "$JSON_FILE" <<EOF
{
  "friendlyarm,nanopi-r4se": [
    {
      "build_date": "$BUILD_DATE",
      "sha256sum": "$SHA256",
      "url": "$OTA_BASE_URL/Rockchip/istoreos-rockchip-armv8-friendlyarm_nanopi-r2s-squashfs-sysupgrade.img.gz"
    }
  ]
}
EOF

echo "OTA JSON 文件已生成: $JSON_FILE"
