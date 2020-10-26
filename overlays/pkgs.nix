self: super:
{
  display-switch-config = super.runCommand "display-switch-config"
    {
      config = ../config/display-switch/display-switch.ini;
    } ''
    mkdir -p "$out/display-switch"
    cp "$config" "$out/display-switch/display-switch.ini"
  '';

  display-switch = super.callPackage ../pkgs/display-switch.nix { };

  interception-tools-plugins = super.interception-tools-plugins // {
    dual-function-keys = super.callPackage ../pkgs/dual-function-keys.nix { };
  };
}
