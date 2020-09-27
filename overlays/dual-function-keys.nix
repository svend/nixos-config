self: super:
{
  interception-tools-plugins = super.interception-tools-plugins // {
    dual-function-keys = super.callPackage ../pkgs/dual-function-keys.nix { };
  };
}
