{ config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Synaptics conflicts with libinput
  # services.xserver.synaptics.enable = true;

  # Enable the Gnome Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # I use gpg-agent for SSH
  # https://github.com/NixOS/nixpkgs/issues/42291#issuecomment-687979733
  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;

  environment.systemPackages = with pkgs; [
    # chromium
    gcompris # educational software
    # google-chrome
    (firefox.override { extraNativeMessagingHosts = [ passff-host ]; })
    gimp
    inkscape
    xorg.xev # keyboard/mouse event viewer
  ];
}
