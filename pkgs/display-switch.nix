{ lib, stdenv, fetchFromGitHub, rustPlatform, udev, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "display-switch";
  version = "dev";

  src = fetchFromGitHub {
    owner = "haimgel";
    repo = "display-switch";
    rev = "1.1.0";
    sha256 = "sha256-jucXTVuC3H7/fkn9Z/d2ElbpRI135EooYnCfRIVuUy0=";
  };

  cargoSha256 = "sha256-IJRlBto5CKAIuPMzhEjpdj9DKXqJ/Hvn+oxi9bqwbjw=";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ udev ];

  doCheck = false;

  meta = with lib; {
    description = "";
    homepage = "";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all; # Linux, Darwin, Windows
  };
}
