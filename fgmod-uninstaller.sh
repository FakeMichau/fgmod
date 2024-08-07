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
    rm "dlssg_to_fsr3_amd_is_better-3.0.dll"
    rm "dlssg_to_fsr3.log"
    rm "dlss-enabler-upscaler.dll"
    rm "Optiscaler.log" 2>/dev/null
    rm "nvngx.ini"
    rm "libxess.dll"
    rm "d3dcompiler_47.dll"

    # Restore files the game might've shipped with
    mv -f "libxess.dll.b" "libxess.dll" 2>/dev/null
    mv -f "d3dcompiler_47.dll.b" "d3dcompiler_47.dll" 2>/dev/null
    mv -f "amd_fidelityfx_dx12.dll.b" "amd_fidelityfx_dx12.dll" 2>/dev/null
    mv -f "amd_fidelityfx_vk.dll.b" "amd_fidelityfx_vk.dll" 2>/dev/null

    echo "fgmod removed from this game"
    echo "Don't forget to remove /home/USERNAME/fgmod/fgmod from the launch options!"

    rm "$0" # remove the uninstaller itself
fi