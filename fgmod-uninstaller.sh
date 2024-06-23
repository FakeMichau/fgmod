#!/bin/bash

mod_path="/usr/share/fgmod"

if [[ $(pwd) == "$mod_path" ]]; then
    rm -r $mod_path
else
    rm "dlss-enabler.dll"
    rm "dlss-enabler.log"
    rm "dxgi.dll"
    rm "nvapi64-proxy.dll" 
    rm "nvngx-wrapper.dll"
    rm "_nvngx.dll"
    rm "dlssg_to_fsr3_amd_is_better.dll"
    rm "dlssg_to_fsr3.log"
    rm "dlss-enabler-upscaler.dll"
    rm "nvngx.ini"

    # Can't remove those because the game might've shipped with those
    # TODO: add a mark to them during installation
    # rm "libxess.dll" "d3dcompiler_47.dll"

    echo "fgmod removed from this game"
    echo "Don't forget to remove /home/USERNAME/fgmod/fgmod from the launch options!"

    rm "$0" # remove the uninstaller itself
fi