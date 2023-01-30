{ config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # I use gpg-agent for SSH
  # https://github.com/NixOS/nixpkgs/issues/42291#issuecomment-687979733
  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;

  services.xserver.desktopManager.gnome = {
    # Show local overrides: dconf dump /org/gnome/
    # Reset to default: dconf reset /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type
    extraGSettingsOverrides = ''
      # Do not sleep when on AC power
      [settings-daemon/plugins/power]
      sleep-inactive-ac-type='nothing'
    '';

    extraGSettingsOverridePackages = [
      pkgs.gsettings-desktop-schemas # for org.gnome.desktop
      pkgs.gnome.gnome-shell # for org.gnome.shell
    ];
  };

  environment.systemPackages = with pkgs; [
    acpi # acpi CLI, show CPU temps, etc
    # chromium
    gcompris # educational software
    google-chrome
    (firefox.override { extraNativeMessagingHosts = [ passff-host ]; })
    gimp
    inkscape
    traceroute
    xorg.xev # keyboard/mouse event viewer
  ];
}
