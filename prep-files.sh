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

tbb_tar="tor-browser-linux${aa}-$1_en-US.tar.xz"
tbb_path="tor-browser_en-US/Browser"

[ -f "$tbb_tar" ] || die "error: No $tbb_tar file found"

tar xf "$tbb_tar" || die "error: Failed extracting $tbb_tar"

cd "$tbb_path"

rm -f dictionaries/*
ln -s /usr/share/hunspell/*.aff dictionaries/
ln -s /usr/share/hunspell/*.dic dictionaries/

rm -r TorBrowser/Tor TorBrowser/Docs
rm TorBrowser/Data/Browser/profile.default/extensions/tor-launcher@torproject.org.xpi
mkdir -p TorBrowser/Data/Browser/Caches TorBrowser/UpdateInfo

cd -

tmp="$(mktemp -d)"
wd="$(pwd)"
cd "$tmp"

7z x -tzip "$wd/$tbb_path/browser/omni.ja"
sed '/extensions\.torlauncher\/.d' -i defaults/preferences/000-tor-browser.js
cat "$wd/tor-browser-prefs.js" >> defaults/preferences/000-tor-browser.js
rm "$wd/$tbb_path/browser/omni.ja"
7z a -mtc=off -tzip "$wd/$tbb_path/browser/omni.ja" *

cd -
rm -r "$tmp"
