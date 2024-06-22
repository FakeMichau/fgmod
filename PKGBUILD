pkgname=fgmod
pkgver=1.2.0
pkgrel=1
pkgdesc="Makes \"DLSS\" Enabler easy to use on Linux with Proton"
arch=('x86_64')
license=('custom')
depends=('zenity')
makedepends=('innoextract')
_nvidiaver=555.52.04
source=("https://github.com/artur-graniszewski/DLSS-Enabler/releases/download/2.90.800.0-beta15/dlss-enabler-setup-2.90.800.0-b15.exe"
        "https://download.nvidia.com/XFree86/Linux-x86_64/$_nvidiaver/NVIDIA-Linux-x86_64-$_nvidiaver.run"
        "https://raw.githubusercontent.com/mozilla/fxc2/master/dll/d3dcompiler_47.dll" # from winetricks
        "fgmod.sh"
        "fgmod-uninstaller.sh")
sha256sums=('cbf05b8af7b24d6cc3b493fb91953e12bc8e6f14ec1a8a5bef08e4a1b285bdb6'
            '9d53ae6dbef32ae95786ec7d02bb944d5050c1c70516e6065ab5356626a44402'
            '4432bbd1a390874f3f0a503d45cc48d346abc3a8c0213c289f4b615bf0ee84f3'
            'SKIP'
            'SKIP')

_moddir=usr/share/${pkgname}

prepare() {
    chmod +x NVIDIA-Linux-x86_64-$_nvidiaver.run
    rm -rf NVIDIA-Linux-x86_64-555.52.04
    ./NVIDIA-Linux-x86_64-$_nvidiaver.run -x

    innoextract dlss-enabler-setup-2.90.800.0-b15.exe
}

package() {
    install -d "$pkgdir"/usr/share/$pkgname
    cp -a app/* "$pkgdir"/usr/share/$pkgname
    cp d3dcompiler_47.dll "$pkgdir"/usr/share/$pkgname

    rm "$pkgdir"/usr/share/$pkgname/_nvngx.dll
    cp "NVIDIA-Linux-x86_64-$_nvidiaver/nvngx.dll" "$pkgdir"/usr/share/$pkgname/_nvngx.dll
    chmod +r "$pkgdir"/usr/share/$pkgname/_nvngx.dll
    
    cp "fgmod.sh" "$pkgdir"/usr/share/$pkgname/
    cp "fgmod-uninstaller.sh" "$pkgdir"/usr/share/$pkgname/

    install -d "$pkgdir"/usr/bin
    ln -s /usr/share/$pkgname/fgmod.sh "$pkgdir"/usr/bin/$pkgname

    # Licenses
    install -Dm644 "NVIDIA-Linux-x86_64-$_nvidiaver/LICENSE" "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
    install -Dm644 "app/LICENSE (DLSSG to FSR3 mod).txt" "$pkgdir"/usr/share/licenses/$pkgname/"LICENSE (DLSSG to FSR3 mod).txt"
    install -Dm644 "app/XESS LICENSE.pdf" "$pkgdir"/usr/share/licenses/$pkgname/"XESS LICENSE.pdf"
}