{ stdenv
, fetchFromGitLab
, pkgconfig
, libyamlcpp
, libevdev
}:

stdenv.mkDerivation rec {
  pname = "dual-function-keys";
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "interception/linux/plugins";
    repo = pname;
    rev = version;
    sha256 = "sha256-xlplbkeptXMBlRnSsc5NgGJfT8aoZxTRgTwTOd7aiWg=";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libevdev libyamlcpp ];

  prePatch = ''
    substituteInPlace config.mk --replace \
      '/usr/include/libevdev-1.0' \
      "$(pkg-config --cflags libevdev | cut -c 3-)"
  '';

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = with stdenv.lib; {
    homepage = "https://gitlab.com/interception/linux/plugins/dual-function-keys";
    description = "Tap for one key, hold for another.";
    license = licenses.mit;
    maintainers = [ maintainers.svend ];
    platforms = platforms.linux;
  };
}
