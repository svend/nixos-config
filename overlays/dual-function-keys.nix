self: super:
{
  # TODO: find way to add to existing interception-tools-plugins
  interception-tools-plugins = {
    caps2esc = super.interception-tools-plugins.caps2esc;
    dual-function-keys = super.callPackage ../pkgs/dual-function-keys.nix { };
  };
}
