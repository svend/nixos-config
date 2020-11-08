self: super:
{
  display-switch = super.callPackage ../pkgs/display-switch.nix { };
  interception-tools-plugins = super.interception-tools-plugins // {
    dual-function-keys = super.callPackage ../pkgs/dual-function-keys.nix { };
  };
}
