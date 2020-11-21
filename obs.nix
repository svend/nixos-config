{ config, pkgs, ... }:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.kernelModules = [
    "v4l2loopback"
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=5,6
  '';

  environment.systemPackages = with pkgs; [
    gstreamer.dev
    obs-studio
    obs-v4l2sink
    v4l-utils
  ];
}
