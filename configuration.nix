# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  dualFunctionKeysConfig = pkgs.writeText "dual-function-keys.yaml" ''
    TIMING:
      TAP_MILLISEC: 200
      DOUBLE_TAP_MILLISEC: 150

    # See https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h
    MAPPINGS:

      # Space as control key
      - KEY: KEY_SPACE
        TAP: KEY_SPACE
        HOLD: KEY_RIGHTCTRL

      # Left shift on Thinkpad X230 has developed an issue where pressing righ-shift
      # results in shift and pgup. Disable pgup (keycode 112). (Use `xev` to debug.)
      - KEY: KEY_PAGEUP
        TAP: KEY_RIGHTSHIFT
        HOLD: KEY_RIGHTSHIFT
  '';
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # hardware.trackpoint.emulateWheel = true;
  # hardware.opengl.driSupport32Bit = true; # required by Steam

  # Enable Nix Flakes: https://nixos.wiki/wiki/Flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
  };

  nixpkgs.config.allowUnfree = true;
  # TODO: remove once merged: https://github.com/NixOS/nixpkgs/pull/94097
  nixpkgs.overlays = [ (import ./overlays/pkgs.nix) ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # DDC support (/dev/i2c-*)
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", TAG+="uaccess"
  '';

  boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/9e52e0a1-1e3c-4798-8dca-403df741691b";
      preLVM = true;
      allowDiscards = true;
    };
  };

  networking = {
    hostName = "quartz"; # Define your hostname.
    hostId = "84821397";
  };

  # WireGuard server is down
  # networking.wireguard.interfaces = {
  #   # "wg0" is the network interface name. You can name the interface arbitrarily.
  #   wg0 = {
  #     # Determines the IP address and subnet of the client's end of the tunnel interface.
  #     ips = [ "10.0.0.2/24" "fd00::2/48" ];
  #     # Default IPv6 route has lower precedence
  #     # default via fe80::d6ca:6dff:fe06:c6b1 dev wlp3s0 proto ra metric 600 pref medium
  #     # default dev wg0 metric 1024 pref medium
  #     postSetup = "ip route replace ::/0 dev wg0 metric 50 table main";
  #     postShutdown = "ip route delete ::/0 dev wg0 metric 50 table main";
  #     privateKeyFile = "/etc/nixos/wireguard/private";
  #     peers = [
  #       {
  #         publicKey = "S3XliYkSL3e+oX8gU+uBu4fk1RmzHUZYBFzVXLa3zww=";
  #         allowedIPs = [ "0.0.0.0/0" "::/0" ];
  #         endpoint = "[2601:601:e02:dc88:21e:37ff:feda:dd22]:53605";
  #         # Send keepalives every 25 seconds. Important to keep NAT tables alive.
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "US/Pacific";

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    chromium
    mkpasswd
    gcompris
    google-chrome
    (firefox.override { extraNativeMessagingHosts = [ passff-host ]; })
    (firefox-beta-bin.override { extraNativeMessagingHosts = [ passff-host ]; })
    gimp
    inkscape
    smartmontools
    steam
    qrencode # to print wireguard QR codes
    usbutils
    wireguard
    xorg.xev
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  services.avahi = {
    enable = true;
    nssmdns = true;
    # publish.enable = true;
    # publish.addresses = true;
    # publish.workstation = true;
  };

  services.interception-tools = {
    enable = true;
    # https://github.com/NixOS/nixpkgs/pull/94097
    # sudo nixos-rebuild -I nixpkgs=/home/svend/src/nixpkgs switch
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
      - JOB: "intercept -g $DEVNODE | dual-function-keys -c ${dualFunctionKeysConfig} | uinput -d $DEVNODE"
        DEVICE:
          NAME: AT Translated Set 2 keyboard
      - JOB: "intercept -g $DEVNODE | dual-function-keys -c ${dualFunctionKeysConfig} | uinput -d $DEVNODE"
        DEVICE:
          NAME: Lenovo ThinkPad Compact USB Keyboard with TrackPoint
    '';
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "lock";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [
      pkgs.epson-escpr2 # Epson ET-3760
      # pkgs.hplip # HP inkjet (obsolete)
    ];
  };

  services.pcscd.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the Gnome Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  systemd.services.display-switch = {
    description = "USB-triggered display switch";
    environment = {
      XDG_CONFIG_HOME = pkgs.display-switch-config;
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.display-switch}/bin/display_switch";
    };
    # Will fail to start if display is not connected
    # wantedBy = [ "default.target" ];
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  users = {
    mutableUsers = false;

    extraUsers.svend = {
      createHome = true;
      home = "/home/svend";
      extraGroups = [ "docker" "networkmanager" "wheel" ];
      useDefaultShell = true;
      uid = 1000;
      group = "svend";
      # mkpasswd -m sha-512 | sudo tee /etc/passwd.d/svend
      passwordFile = "/etc/passwd.d/svend";
    };
    extraGroups.svend = {
      gid = 1000;
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
}
