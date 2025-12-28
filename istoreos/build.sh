#!/bin/bash -e
export RED_COLOR='\e[1;31m'
export GREEN_COLOR='\e[1;32m'
export YELLOW_COLOR='\e[1;33m'
export BLUE_COLOR='\e[1;34m'
export PINK_COLOR='\e[1;35m'
export SHAN='\e[1;33;5m'
export RES='\e[0m'

GROUP=
group() {
    endgroup
    echo "::group::  $1"
    GROUP=1
}
endgroup() {
    if [ -n "$GROUP" ]; then
        echo "::endgroup::"
    fi
    GROUP=
}

# check
if [ "$(whoami)" != "zhao" ] && [ -z "$git_name" ] && [ -z "$git_password" ]; then
    echo -e "\n${RED_COLOR} Not authorized. Execute the following command to provide authorization information:${RES}\n"
    echo -e "${BLUE_COLOR} export git_name=your_username git_password=your_password${RES}\n"
    exit 1
fi

# IP Location
ip_info=`curl -sk https://ip.kejizero.xyz`;
[ -n "$ip_info" ] && export isCN=`echo $ip_info | grep -Po 'country_code\":"\K[^"]+'` || export isCN=US

# script url
export mirror=https://init.kejizero.xyz

# github actions - caddy server
if [ "$(whoami)" = "runner" ] && [ "$git_name" != "private" ]; then
    export mirror=http://127.0.0.1:8080
fi

# private gitea
export gitea="gitea.kejizero.xyz"

# github mirror
if [ "$isCN" = "CN" ]; then
    # There is currently no stable gh proxy
    export github="github.com"
    code_mirror="git.cooluc.com"
else
    export github="github.com"
    code_mirror="github.com"
fi

# Check root
if [ "$(id -u)" = "0" ]; then
    export FORCE_UNSAFE_CONFIGURE=1 FORCE=1
fi

# Start time
starttime=`date +'%Y-%m-%d %H:%M:%S'`
CURRENT_DATE=$(date +%s)

# Cpus
cores=`expr $(nproc --all) + 1`

# $CURL_BAR
if curl --help | grep progress-bar >/dev/null 2>&1; then
    CURL_BAR="--progress-bar";
fi

SUPPORTED_BOARDS="rockchip x86_64"

if [ -z "$1" ] || ! echo "$SUPPORTED_BOARDS" | grep -qw "$2"; then
    echo -e "\n${RED_COLOR}Release type not specified or unsupported board: '$2'.${RES}\n"
    echo -e "Usage:\n"

    for board in $SUPPORTED_BOARDS; do
        echo -e "$board releases: ${GREEN_COLOR}bash build.sh v24 $board${RES}"
    done
    echo
    exit 1
fi

# Source branch
export branch=istoreos-24.10
export version=v24

# lan
[ -n "$LAN" ] && export LAN=$LAN || export LAN=10.0.0.1

# platform
case "$2" in
    rockchip)
        platform="aarch64_generic"
        toolchain_arch="aarch64_generic"
        ;;
    x86_64)
        platform="x86_64"
        toolchain_arch="x86_64"
        ;;
esac
export platform toolchain_arch

# build.sh flags
export \
    ENABLE_LRNG=$ENABLE_LRNG \
    ROOT_PASSWORD=$ROOT_PASSWORD

# print version
echo -e "\r\n${GREEN_COLOR}Building $branch${RES}\r\n"
case "$platform" in
    x86_64)
        echo -e "${GREEN_COLOR}Model: x86_64${RES}"
        ;;
    rockchip)
        echo -e "${GREEN_COLOR}Model: rockchip${RES}"
        ;;
esac

# print build opt
get_kernel_version=$(curl -s $mirror/tags/kernel-6.12)
kmod_hash=$(echo -e "$get_kernel_version" | awk -F'HASH-' '{print $2}' | awk '{print $1}' | tail -1 | md5sum | awk '{print $1}')
kmodpkg_name=$(echo $(echo -e "$get_kernel_version" | awk -F'HASH-' '{print $2}' | awk '{print $1}')~$(echo $kmod_hash)-r1)
echo -e "${GREEN_COLOR}Kernel: $kmodpkg_name ${RES}"
echo -e "${GREEN_COLOR}Date: $CURRENT_DATE${RES}\r\n"
echo -e "${GREEN_COLOR}SCRIPT_URL:${RES} ${BLUE_COLOR}$mirror${RES}\r\n"
echo -e "${GREEN_COLOR}GCC VERSION: $gcc_version${RES}"
print_status() {
    local name="$1"
    local value="$2"
    local true_color="${3:-$GREEN_COLOR}"
    local false_color="${4:-$YELLOW_COLOR}"
    local newline="${5:-}"
    if [ "$value" = "y" ]; then
        echo -e "${GREEN_COLOR}${name}:${RES} ${true_color}true${RES}${newline}"
    else
        echo -e "${GREEN_COLOR}${name}:${RES} ${false_color}false${RES}${newline}"
    fi
}
[ -n "$LAN" ] && echo -e "${GREEN_COLOR}LAN:${RES} $LAN" || echo -e "${GREEN_COLOR}LAN:${RES} 10.0.0.1"
[ -n "$ROOT_PASSWORD" ] \
    && echo -e "${GREEN_COLOR}Default Password:${RES} ${BLUE_COLOR}$ROOT_PASSWORD${RES}" \
    || echo -e "${GREEN_COLOR}Default Password:${RES} (${YELLOW_COLOR}No password${RES})"
[ "$ENABLE_GLIBC" = "y" ] && echo -e "${GREEN_COLOR}Standard C Library:${RES} ${BLUE_COLOR}glibc${RES}" || echo -e "${GREEN_COLOR}Standard C Library:${RES} ${BLUE_COLOR}musl${RES}"
print_status "ENABLE_OTA"        "$ENABLE_OTA"
print_status "ENABLE_LRNG"       "$ENABLE_LRNG" "$GREEN_COLOR" "$RED_COLOR"
print_status "ENABLE_LOCAL_KMOD" "$ENABLE_LOCAL_KMOD"
print_status "BUILD_FAST"        "$BUILD_FAST"

# clean old files
rm -rf openwrt

# openwrt - releases
[ "$(whoami)" = "runner" ] && group "source code"
git clone --depth=1 https://$code_mirror/istoreos/istoreos -b $branch

if [ -d openwrt ]; then
    cd openwrt
    curl -Os $mirror/openwrt/patch/key.tar.gz && tar zxf key.tar.gz && rm -f key.tar.gz
else
    echo -e "${RED_COLOR}Failed to download source code${RES}"
    exit 1
fi

# tags
git branch | awk '{print $2}' > version.txt

