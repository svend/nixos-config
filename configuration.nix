# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./display-switch.nix
      ./nix-flakes.nix
      ./obs-studio.nix
      ./steam.nix
      ./wireguard.nix
      ./xserver.nix
    ];

  # Enable automatic updates
  system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;

  services.prometheus = {
    exporters.node = {
      enable = true;
      openFirewall = true;
      firewallFilter = "-i wg0 -p tcp -m tcp --dport 9100";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ (import ./overlays/pkgs.nix) ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/9e52e0a1-1e3c-4798-8dca-403df741691b";
      preLVM = true;
      allowDiscards = true;
    };
  };

  networking = {
    hostName = "quartz";
    hostId = "84821397";
  };

  time.timeZone = "US/Pacific";

  environment.systemPackages = with pkgs; [
    mkpasswd
    smartmontools
    usbutils
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  services.interception-tools =
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

  # services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "lock";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [
      pkgs.epson-escpr2 # Epson ET-3760
    ];
  };

  services.pcscd.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  users = {
    mutableUsers = false;

    extraUsers.svend = {
      description = "Svend Sorensen";
      createHome = true;
      home = "/home/svend";
      extraGroups = [ "docker" "networkmanager" "wheel" ];
      useDefaultShell = true;
      uid = 1000;
      group = "svend";
      # mkpasswd -m sha-512 | sudo tee /etc/nixos-secrets/passwd.d/svend
      # hashedPassword = "";
      passwordFile = "/etc/nixos-secrets/passwd.d/svend";
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
