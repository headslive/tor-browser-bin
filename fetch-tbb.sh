#!/bin/sh
#
# Copy me if you can
# by parazyd
#

die() {
	echo "$*"
	exit 1
}

usage() {
	die "usage: $(basename $0) [tbb-version] [architecture]"
}

[ -n "$1" ] || usage
[ -n "$2" ] || usage

case "$2" in
amd64)
	aa="64"
	;;
i386)
	aa="32"
	;;
esac

tbb_tar="https://www.torproject.org/dist/torbrowser/$1/tor-browser-linux${aa}-$1_en-US.tar.xz"
tbb_sig="https://www.torproject.org/dist/torbrowser/$1/tor-browser-linux${aa}-$1_en-US.tar.xz.asc"

wget -c "${tbb_tar}" || die "Failed fetching $(basename "${tbb_tar}")"
wget -c "${tbb_sig}" || die "Failed fetching $(basename "${tbb_sig}")"

gpg --no-default-keyring --keyring=./tor-keyring.gpg \
	--verify "$(basename "${tbb_sig}")" || die "Failed verifying signature"
