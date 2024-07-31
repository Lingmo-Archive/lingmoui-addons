pkgname=lingmoui-addons
pkgver=1.4.0
pkgrel=1
pkgdesc='Add-ons for the LingmoUI framework'
url='https://invent.kde.org/libraries/kirigami-addons'
arch=(x86_64)
license=(GPL-2.0-or-later
         LGPL-2.1-or-later)
depends=(gcc-libs
         glibc
         kconfig
         kcoreaddons
         kglobalaccel
         kguiaddons
         ki18n
         lingmoui
         kitemmodels
         ksvg
         qt6-base
         qt6-declarative
         qt6-multimedia)
makedepends=(extra-cmake-modules)
source=(git+https://github.com/LingmoOS/$pkgname)
sha256sums=('SKIP'
            'SKIP')
validpgpkeys=(41EF7182553A87AC18196A77F27F2FDA54F067D8) # Lingmo OS Team <team@lingmo.org>

build() {
  cmake -B build -S $pkgname \
    -DBUILD_TESTING=OFF \
    -DBUILD_QCH=ON
  cmake --build build
}

package() {
  DESTDIR="$pkgdir" cmake --install build
}

