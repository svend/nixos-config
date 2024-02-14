self: super: {
  # interception-tools = super.interception-tools.overrideAttrs (old: rec {
  #   version = "0.6.4";
  #   baseName = "interception-tools";
  #     name = "${baseName}-${version}";

  #     src = super.fetchurl {
  #       url = "https://gitlab.com/interception/linux/tools/-/archive/v0.6.4/tools-v0.6.4.tar.gz";
  #       sha256 = "sha256-HDM1iNdv/HZ1oyufkLJEAofR4oUpEKh3goeLRXw2s6E=";
  #     };
  #     patches =[];
  # });
  interception-tools = super.callPackage ../pkgs/interception-tools.nix { };
  display-switch = super.callPackage ../pkgs/display-switch.nix { };
  interception-tools-plugins = super.interception-tools-plugins // {
    dual-function-keys = super.callPackage ../pkgs/dual-function-keys.nix { };
  };
}
