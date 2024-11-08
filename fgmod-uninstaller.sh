#!/usr/bin/env bash

mod_path="/usr/share/fgmod"

if [[ $(pwd) == "$mod_path" ]]; then
    rm -r $mod_path
else
    rm "dlss-enabler.dll"
    rm "dxgi.dll"
    rm "nvngx-wrapper.dll"
    rm "_nvngx.dll"
    rm "dlssg_to_fsr3_amd_is_better.dll"
    rm "dlssg_to_fsr3_amd_is_better-3.0.dll"
    rm "dlss-enabler-upscaler.dll"
    rm "nvngx.ini"
    rm "libxess.dll"
    rm "d3dcompiler_47.dll"
    rm "amd_fidelityfx_dx12.dll"
    rm "amd_fidelityfx_vk.dll"

    # Those files might not exist
    rm "nvapi64.dll" 2>/dev/null
    rm "fakenvapi.ini" 2>/dev/null
    rm "OptiScaler.log" 2>/dev/null
    rm "dlss-enabler.log" 2>/dev/null
    rm "dlssg_to_fsr3.log" 2>/dev/null
    rm "fakenvapi.log" 2>/dev/null

    # Restore files the game might've shipped with
    mv -f "libxess.dll.b" "libxess.dll" 2>/dev/null
    mv -f "d3dcompiler_47.dll.b" "d3dcompiler_47.dll" 2>/dev/null
    mv -f "amd_fidelityfx_dx12.dll.b" "amd_fidelityfx_dx12.dll" 2>/dev/null
    mv -f "amd_fidelityfx_vk.dll.b" "amd_fidelityfx_vk.dll" 2>/dev/null

    echo "fgmod removed from this game"
    echo "Don't forget to remove /home/USERNAME/fgmod/fgmod from the launch options!"

    rm "$0" # remove the uninstaller itself
fi