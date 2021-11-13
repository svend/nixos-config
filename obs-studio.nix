{ config, pkgs, ... }:
{
  # Add the v4l2loopback module package
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  # And load it on boot
  boot.kernelModules = [
    "v4l2loopback"
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=5,6
  '';

  environment.systemPackages = with pkgs; [
    gst_all_1.gstreamer.dev # gst-launch-1.0
    obs-studio
    # Error with nixos-unstable
    # TODO: Need to integrate this into the obs-studio package. For now, symlink
    # to ~/.config/obs-studio/plugins
    #
    # ln -s /nix/store/b7vj20dglnrs8sxhxdb4njya26nfhqbl-obs-v4l2sink-0.1.0-12-g1ec3c8a/share/obs/obs-plugins/v4l2sink  ~/.config/obs-studio/plugins
    # obs-v4l2sink
    v4l-utils
  ];
}
