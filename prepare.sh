#!/usr/bin/env bash

mod_path="$HOME/fgmod"
nvidiaver=555.52.04
enablerver=3.01.001.0-beta11
# standalone makes use of fgmod.sh and fgmod-uninstaller.sh from the working directory
# To make it fully standalone with files being installed to pwd, set standalone=1 and mod_path=.
standalone=0

if [[ -d "$mod_path" ]] && [[ ! $mod_path == . ]]; then
    read -p "$mod_path already exists, override the old version? [y/N] " -n 1 -r </dev/tty
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
    [[ -f fgmod-uninstaller.sh ]] && cp fgmod-uninstaller.sh "$mod_path" || exit 1
fi
cd "$mod_path" || exit 1

curl -OLf https://github.com/artur-graniszewski/DLSS-Enabler/releases/download/$enablerver/dlss-enabler-setup-$enablerver.exe
curl -OLf https://download.nvidia.com/XFree86/Linux-x86_64/$nvidiaver/NVIDIA-Linux-x86_64-$nvidiaver.run
curl -OLf https://raw.githubusercontent.com/mozilla/fxc2/master/dll/d3dcompiler_47.dll
curl -OLf https://github.com/FakeMichau/innoextract/releases/download/6.3.0/innoextract
[[ $standalone -eq 0 ]] && curl -o fgmod -Lf https://raw.githubusercontent.com/FakeMichau/fgmod/main/fgmod.sh
[[ $standalone -eq 0 ]] && curl -OL https://raw.githubusercontent.com/FakeMichau/fgmod/main/fgmod-uninstaller.sh

[[ ! -f dlss-enabler-setup-$enablerver.exe ]] || 
[[ ! -f NVIDIA-Linux-x86_64-$nvidiaver.run ]] || 
[[ ! -f d3dcompiler_47.dll ]] || 
[[ ! -f innoextract ]] || 
[[ ! -f fgmod ]] || 
[[ ! -f fgmod-uninstaller.sh ]] && exit 1

# Extract files
chmod +x NVIDIA-Linux-x86_64-$nvidiaver.run
./NVIDIA-Linux-x86_64-$nvidiaver.run -x

chmod +x innoextract
./innoextract dlss-enabler-setup-$enablerver.exe

# Prepare mod files
mv app/* .
rm -r app
cp -f NVIDIA-Linux-x86_64-$nvidiaver/nvngx.dll _nvngx.dll
cp -f NVIDIA-Linux-x86_64-$nvidiaver/LICENSE LICENSE
chmod +r _nvngx.dll
rm -rf innoextract NVIDIA-Linux-x86_64-$nvidiaver dlss-enabler-setup-$enablerver.exe NVIDIA-Linux-x86_64-$nvidiaver.run
rm -rf plugins dlss-enabler-fsr.dll dlss-enabler-xess.dll version.dll winmm.dll
[[ -f "$(which nvidia-smi)" ]] && rm -rf nvapi64-proxy.dll

sed -i 's|mod_path="/usr/share/fgmod"|mod_path="'"$mod_path"'"|g' fgmod
chmod +x fgmod

sed -i 's|mod_path="/usr/share/fgmod"|mod_path="'"$mod_path"'"|g' fgmod-uninstaller.sh
chmod +x fgmod-uninstaller.sh

echo All done!
echo For Steam, add this to the launch options: "$PWD/fgmod" %COMMAND%
echo For Heroic, add this as a new wrapper: "$PWD/fgmod"
