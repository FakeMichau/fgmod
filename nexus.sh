#!/usr/bin/env bash

source PKGBUILD
rm -rf nexus
mkdir nexus && cd nexus || exit 1
cp ../fgmod.sh ../fgmod-uninstaller.sh ../prepare.sh .
sed -i 's|standalone=0|standalone=1|g' prepare.sh
7z a -t7z "../fgmod $pkgver.7z" fgmod.sh fgmod-uninstaller.sh prepare.sh
rm -rf ../nexus