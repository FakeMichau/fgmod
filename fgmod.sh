#!/bin/bash

error_exit() {
  echo "$1"
  if [[ -n $STEAM_ZENITY ]]; then
    $STEAM_ZENITY --error --text "$1"
  else 
    zenity --error --text "$1"
  fi
  exit 1
}

mod_path="/usr/share/fgmod"

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 program [program_arguments...]"
    exit 1
fi

# One arg means the command is ran standalone
if [[ $# -eq 1 ]]; then
  if [[ "$1" == *.exe ]]; then
    exe_folder_path=$(dirname "$1")
  else
    exe_folder_path=$1
  fi
else
  for arg in "$@"; do
    if [[ "$arg" == *.exe ]]; then
      # Special cases, only FG-supported games
      [[ "$arg" == *"Cyberpunk 2077"* ]] && arg=${arg//REDprelauncher.exe/bin/x64/Cyberpunk2077.exe}
      [[ "$arg" == *"Witcher 3"* ]]      && arg=${arg//REDprelauncher.exe/bin/x64_dx12/witcher3.exe}
      [[ "$arg" == *"HITMAN 3"* ]]       && arg=${arg//Launcher.exe/Retail/HITMAN3.exe}
      [[ "$arg" == *"SYNCED"* ]]         && arg=${arg//Launcher\/sop_launcher.exe/SYNCED.exe} # UE with a launcher
      [[ "$arg" == *"2KLauncher"* ]]     && arg=${arg//2KLauncher\/LauncherPatcher.exe/DoesntMatter.exe} # 2K launcher games
      [[ "$arg" == *"Warhammer 40,000 DARKTIDE"* ]] && arg=${arg//launcher\/Launcher.exe/binaries/Darktide.exe}
      [[ "$arg" == *"Warhammer Vermintide 2"* ]]    && arg=${arg//launcher\/Launcher.exe/binaries_dx12/vermintide2_dx12.exe}
      exe_folder_path=$(dirname "$arg")
      break
    fi
  done
fi

# Fallback to STEAM_COMPAT_INSTALL_PATH when no path was found
if [[ ! -d $exe_folder_path ]] && [[ -n ${STEAM_COMPAT_INSTALL_PATH} ]]; then
  echo "Trying the path from STEAM_COMPAT_INSTALL_PATH"
  exe_folder_path=${STEAM_COMPAT_INSTALL_PATH}
fi

# Check for UE games
if [[ -d "$exe_folder_path/Engine" ]]; then
  ue_exe_path=$(find "$exe_folder_path" -maxdepth 4 -mindepth 4 -path "*Binaries/Win64/*.exe" -not -path "*/Engine/*" | head -1)
  exe_folder_path=$(dirname "$ue_exe_path")
fi

if [[ -d $exe_folder_path ]]; then
  if [[ ! -w $exe_folder_path ]]; then
    error_exit "No write permission to the game folder!"
  fi
  # TODO: fail on copy fail?
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

  cp -f "$mod_path/fgmod-uninstaller.sh" "$exe_folder_path"
else
  error_exit "Path doesn't exist!"
fi

# Execute the original command
export SteamDeck=0
export WINEDLLOVERRIDES="$WINEDLLOVERRIDES,dxgi=n,b"
[[ $# -gt 1 ]] && env "$@"