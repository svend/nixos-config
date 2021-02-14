# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  # To set device libinput device quirks, set environment.etc
  # libinput/local-overrides.quirks https://github.com/NixOS/nixpkgs/pull/70520

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./display-switch.nix
      ./interception-tools.nix
      ./nix-flakes.nix
      ./obs-studio.nix
      ./prometheus.nix
      ./steam.nix
      ./wireguard.nix
      ./xserver.nix
    ];

  # Enable automatic updates
  # TODO: Do automatic upgrades work with flakes?
  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;

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
    libinput
    mkpasswd
    smartmontools
    usbutils
  ];

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
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
