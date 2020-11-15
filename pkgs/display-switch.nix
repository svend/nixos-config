{ stdenv, fetchFromGitHub, rustPlatform, udev, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "display-switch";
  version = "dev";

  src = fetchFromGitHub {
    owner = "svend";
    repo = "display-switch";
    rev = "e9c49b94014d680946117fecfdf55d6b04d1daa9";
    sha256 = "sha256-dSzFH+CCKsRrYUbPLpKN1OV7Db8eYBG/kxf0/Y945OA=";
  };

  cargoSha256 = "sha256-eJgIfzQn36GJyj9ahdhZpIsKMWtmyGsz9RzgFJh8sJU=";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ udev ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "";
    homepage = "";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all; # Linux, Darwin, Windows
  };
}
