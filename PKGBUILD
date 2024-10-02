pkgname=fgmod
pkgver=1.5.0
pkgrel=1
pkgdesc="Makes \"DLSS\" Enabler easy to use on Linux with Proton"
arch=('x86_64')
license=('custom')
depends=('zenity')
_nvidiaver=555.52.04
_enablerver=3.02.000.0
source=("https://github.com/artur-graniszewski/DLSS-Enabler/releases/download/$_enablerver/dlss-enabler-setup-$_enablerver.exe"
        "https://download.nvidia.com/XFree86/Linux-x86_64/$_nvidiaver/NVIDIA-Linux-x86_64-$_nvidiaver.run"
        "https://raw.githubusercontent.com/mozilla/fxc2/master/dll/d3dcompiler_47.dll" # from winetricks
        "https://github.com/FakeMichau/innoextract/releases/download/6.3.0/innoextract"
        "fgmod.sh"
        "fgmod-uninstaller.sh")
sha256sums=('6f373a7c198ac0f7e9a6a4a5250783c265e8390059171cead5595b5a0801dc1f'
            '9d53ae6dbef32ae95786ec7d02bb944d5050c1c70516e6065ab5356626a44402'
            '4432bbd1a390874f3f0a503d45cc48d346abc3a8c0213c289f4b615bf0ee84f3'
            'SKIP'
            'SKIP'
            'SKIP')

_moddir=usr/share/$pkgname

prepare() {
    chmod +x NVIDIA-Linux-x86_64-$_nvidiaver.run
    rm -rf NVIDIA-Linux-x86_64-555.52.04
    ./NVIDIA-Linux-x86_64-$_nvidiaver.run -x

    chmod +x innoextract
    ./innoextract dlss-enabler-setup-$_enablerver.exe
}

package() {
    install -d "$pkgdir/$_moddir"
    cp -a app/* "$pkgdir/$_moddir"
    cp d3dcompiler_47.dll "$pkgdir/$_moddir"

    rm "$pkgdir/$_moddir/_nvngx.dll"
    cp "NVIDIA-Linux-x86_64-$_nvidiaver/nvngx.dll" "$pkgdir/$_moddir/_nvngx.dll"
    chmod +r "$pkgdir/$_moddir/_nvngx.dll"
    
    cp "fgmod.sh" "$pkgdir/$_moddir/"
    cp "fgmod-uninstaller.sh" "$pkgdir/$_moddir/"

    install -d "$pkgdir/usr/bin"
    ln -s "/$_moddir/fgmod.sh" "$pkgdir/usr/bin/$pkgname"

    # Licenses
    install -Dm644 "NVIDIA-Linux-x86_64-$_nvidiaver/LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    install -Dm644 "app/LICENSE (DLSSG to FSR3 mod).txt" "$pkgdir/usr/share/licenses/$pkgname/LICENSE (DLSSG to FSR3 mod).txt"
    install -Dm644 "app/XESS LICENSE.pdf" "$pkgdir/usr/share/licenses/$pkgname/XESS LICENSE.pdf"

    echo All done!
    echo For Steam, add this to the launch options: fgmod %COMMAND%
    echo For Heroic, add this as a new wrapper: fgmod
}