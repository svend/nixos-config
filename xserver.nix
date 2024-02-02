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
    # nix shell nix shell nixpkgs#gnome.dconf-editor
    # gsettings get org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type
    # gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
    # gsettings reset org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type
    #
    # Show local overrides: dconf dump /
    # Reset to default:
    # dconf reset /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type
    extraGSettingsOverrides = ''
      [org.gnome.desktop.peripherals.mouse]
      natural-scroll=true

      [org.gnome.desktop.wm.keybindings]
      activate-window-menu=@as []
      switch-input-source=@as []
      switch-input-source-backward=@as []

      [org.gnome.shell.keybindings]
      toggle-overview=['<Super>space']

      [org.gnome.settings-daemon.plugins.media-keys]
      screensaver=['<Shift><Super>l']

      # Do not sleep when on AC power
      [org.gnome.settings-daemon.plugins.power]
      sleep-inactive-ac-type='nothing'
    '';

    extraGSettingsOverridePackages = [
      pkgs.gsettings-desktop-schemas # for org.gnome.desktop
      pkgs.gnome.gnome-shell # for org.gnome.shell
      pkgs.gnome.gnome-settings-daemon # https://github.com/NixOS/nixpkgs/issues/42053#issuecomment-397474298
    ];
  };

  environment.systemPackages = with pkgs; [
    acpi # acpi CLI, show CPU temps, etc
    # chromium
    gcompris # educational software
    gnome.dconf-editor # for dconf-editor and gsettings
    google-chrome
    (firefox.override { extraNativeMessagingHosts = [ passff-host ]; })
    gimp
    inkscape
    libnotify # notify-send
    libreoffice
    hunspell # spelling for libreoffice
    traceroute
    xorg.xev # keyboard/mouse event viewer
  ];
}
