#!/bin/bash

if ! which curl &> /dev/null; then
  echo "You don't have curl installed. Install it and try again"
fi

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 folder_with_game_exe"
    exit 1
fi

if [[ "$1" == *.exe ]]; then
  exe_folder_path=$(dirname "$1")
else
  exe_folder_path=$1
fi

if [[ -d $exe_folder_path ]]; then
  if [[ ! -d "data" ]]; then
    mkdir data && cd data || exit 1
    curl -OL https://github.com/artur-graniszewski/DLSS-Enabler/releases/download/2.90.800.0-beta15/dlss-enabler-setup-2.90.800.0-b15.exe
    curl -OL https://download.nvidia.com/XFree86/Linux-x86_64/555.52.04/NVIDIA-Linux-x86_64-555.52.04.run
    curl -OL https://raw.githubusercontent.com/mozilla/fxc2/master/dll/d3dcompiler_47.dll
    curl -OL https://constexpr.org/innoextract/files/innoextract-1.9-linux.tar.xz

    [[ ! -f dlss-enabler-setup-2.90.800.0-b15.exe ]] || [[ ! -f NVIDIA-Linux-x86_64-555.52.04.run ]] || [[ ! -f d3dcompiler_47.dll ]] || [[ ! -f innoextract-1.9-linux.tar.xz ]] && exit 2

    chmod +x NVIDIA-Linux-x86_64-555.52.04.run
    ./NVIDIA-Linux-x86_64-555.52.04.run -x

    tar xf innoextract-1.9-linux.tar.xz
    innoextract-1.9-linux/bin/amd64/innoextract dlss-enabler-setup-2.90.800.0-b15.exe

    cd app || exit 3
    cp -f ../NVIDIA-Linux-x86_64-555.52.04/nvngx.dll _nvngx.dll
    chmod +r _nvngx.dll
    cp -f ../d3dcompiler_47.dll .
    cd ..
    rm -rf innoextract-1.9-linux NVIDIA-Linux-x86_64-555.52.04 innoextract-1.9-linux.tar.xz dlss-enabler-setup-2.90.800.0-b15.exe NVIDIA-Linux-x86_64-555.52.04.run
    cd ..
  fi

  mod_path="data/app"

  # DLSS Enabler
  cp -f "$mod_path/version.dll" "$exe_folder_path/dlss-enabler.dll"
  cp -f "$mod_path/dxgi.dll" "$exe_folder_path"
  cp -f "$mod_path/nvapi64-proxy.dll" "$exe_folder_path"
  cp -f "$mod_path/nvngx-wrapper.dll" "$exe_folder_path"

  # Nvidia's dll
  cp -f "$mod_path/_nvngx.dll" "$exe_folder_path"

  # dlssg-to-fsr3
  cp -f "$mod_path/dlssg_to_fsr3_amd_is_better.dll" "$exe_folder_path"

  # Optiscaler
  cp -f "$mod_path/dlss-enabler-upscaler.dll" "$exe_folder_path"
  cp -f "$mod_path/libxess.dll" "$exe_folder_path"
  cp -n "$mod_path/d3dcompiler_47.dll" "$exe_folder_path"
  cp -n "$mod_path/nvngx.ini" "$exe_folder_path"

  echo "Files copied over"
  echo "Don't forget to add WINEDLLOVERRIDES=dxgi=n,b to your environment variables"
  echo "For Steam add this to your launch options: WINEDLLOVERRIDES=dxgi=n,b %COMMAND%"
else
  echo "Not a folder that exists"
fi