{ lib, stdenv, fetchurl, pkgconfig, cmake, libyamlcpp,
  libevdev, udev, boost }:

let
  version = "0.6.4";
  baseName = "interception-tools";
in stdenv.mkDerivation {
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "https://gitlab.com/interception/linux/tools/-/archive/v0.6.4/tools-v0.6.4.tar.gz";
    sha256 = "sha256-HDM1iNdv/HZ1oyufkLJEAofR4oUpEKh3goeLRXw2s6E=";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libevdev udev libyamlcpp boost ];

  prePatch = ''
    substituteInPlace CMakeLists.txt --replace \
      '"/usr/include/libevdev-1.0"' \
      "\"$(pkg-config --cflags libevdev | cut -c 3-)\""
  '';

  patches = [ ./fix-udevmon-configuration-job-path.patch ];

  meta = {
    description = "A minimal composable infrastructure on top of libudev and libevdev";
    homepage = "https://gitlab.com/interception/linux/tools";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.vyp ];
    platforms = lib.platforms.linux;
  };
}
