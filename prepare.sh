#!/bin/bash

mod_path="$HOME/fgmod"

if [[ -d "$mod_path" ]]; then
    read -p "$mod_path already exists, remove it? [y/Y] " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -r "$mod_path"
    else
        echo Aborting...
        exit 1
    fi
fi
mkdir "$mod_path" && cd "$mod_path" || exit 1

curl -OL https://github.com/artur-graniszewski/DLSS-Enabler/releases/download/2.90.800.0-beta15/dlss-enabler-setup-2.90.800.0-b15.exe
curl -OL https://download.nvidia.com/XFree86/Linux-x86_64/555.52.04/NVIDIA-Linux-x86_64-555.52.04.run
curl -OL https://raw.githubusercontent.com/mozilla/fxc2/master/dll/d3dcompiler_47.dll
curl -OL https://constexpr.org/innoextract/files/innoextract-1.9-linux.tar.xz
curl -o fgmod -L https://raw.githubusercontent.com/FakeMichau/fgmod/main/fgmod.sh

[[ ! -f dlss-enabler-setup-2.90.800.0-b15.exe ]] || [[ ! -f NVIDIA-Linux-x86_64-555.52.04.run ]] || [[ ! -f d3dcompiler_47.dll ]] || [[ ! -f innoextract-1.9-linux.tar.xz ]] && exit 2

# Extract files
chmod +x NVIDIA-Linux-x86_64-555.52.04.run
./NVIDIA-Linux-x86_64-555.52.04.run -x

tar xf innoextract-1.9-linux.tar.xz
innoextract-1.9-linux/bin/amd64/innoextract dlss-enabler-setup-2.90.800.0-b15.exe

# Prepare mod files
mv app/* .
rm -r app
cp -f NVIDIA-Linux-x86_64-555.52.04/nvngx.dll _nvngx.dll
cp -f NVIDIA-Linux-x86_64-555.52.04/LICENSE LICENSE
chmod +r _nvngx.dll
rm -rf innoextract-1.9-linux NVIDIA-Linux-x86_64-555.52.04 innoextract-1.9-linux.tar.xz dlss-enabler-setup-2.90.800.0-b15.exe NVIDIA-Linux-x86_64-555.52.04.run

sed -i 's/\/usr\/share/$HOME/' fgmod

echo All done!
echo Add this to launch options: "$HOME/fgmod/fgmod" %COMMAND%

# TODO: print command to add