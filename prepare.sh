#!/bin/bash

mod_path="$HOME/fgmod"
nvidiaver=555.52.04
# standalone makes use of fgmod.sh from the pwd
# To make it fully standalone with files being installed to pwd, set standalone=1 and mod_path=.
standalone=0

if [[ -d "$mod_path" ]] && [[ ! $mod_path == . ]]; then
    read -p "$mod_path already exists, remove it? [y/Y] " -n 1 -r </dev/tty
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -r "$mod_path"
    else
        echo Aborting...
        exit 1
    fi
fi

mkdir "$mod_path"
if [[ ! $standalone -eq 0 ]]; then
    [[ -f fgmod.sh ]] && cp fgmod.sh "$mod_path/fgmod" || exit 1
fi
cd "$mod_path" || exit 1

curl -OL https://github.com/artur-graniszewski/DLSS-Enabler/releases/download/2.90.800.0-beta15/dlss-enabler-setup-2.90.800.0-b15.exe
curl -OL https://download.nvidia.com/XFree86/Linux-x86_64/$nvidiaver/NVIDIA-Linux-x86_64-$nvidiaver.run
curl -OL https://raw.githubusercontent.com/mozilla/fxc2/master/dll/d3dcompiler_47.dll
curl -OL https://constexpr.org/innoextract/files/innoextract-1.9-linux.tar.xz
[[ $standalone -eq 0 ]] && curl -o fgmod -L https://raw.githubusercontent.com/FakeMichau/fgmod/main/fgmod.sh

[[ ! -f dlss-enabler-setup-2.90.800.0-b15.exe ]] || 
[[ ! -f NVIDIA-Linux-x86_64-$nvidiaver.run ]] || 
[[ ! -f d3dcompiler_47.dll ]] || 
[[ ! -f innoextract-1.9-linux.tar.xz ]] || 
[[ ! -f fgmod ]] && exit 1

# Extract files
chmod +x NVIDIA-Linux-x86_64-$nvidiaver.run
./NVIDIA-Linux-x86_64-$nvidiaver.run -x

tar xf innoextract-1.9-linux.tar.xz
innoextract-1.9-linux/bin/amd64/innoextract dlss-enabler-setup-2.90.800.0-b15.exe

# Prepare mod files
mv app/* .
rm -r app
cp -f NVIDIA-Linux-x86_64-$nvidiaver/nvngx.dll _nvngx.dll
cp -f NVIDIA-Linux-x86_64-$nvidiaver/LICENSE LICENSE
chmod +r _nvngx.dll
rm -rf innoextract-1.9-linux NVIDIA-Linux-x86_64-$nvidiaver innoextract-1.9-linux.tar.xz dlss-enabler-setup-2.90.800.0-b15.exe NVIDIA-Linux-x86_64-$nvidiaver.run

sed -i 's|mod_path="/usr/share/fgmod"|mod_path="'"$mod_path"'"|g' fgmod
chmod +x fgmod

echo All done!
echo Add this to launch options: "$PWD/fgmod" %COMMAND%
