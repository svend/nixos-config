{ config, pkgs, ...  }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the Gnome Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  environment.systemPackages = with pkgs; [
    chromium
    gcompris
    google-chrome
    (firefox.override { extraNativeMessagingHosts = [ passff-host ]; })
    (firefox-beta-bin.override { extraNativeMessagingHosts = [ passff-host ]; })
    gimp
    inkscape
    xorg.xev
  ];
}
