# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/9e52e0a1-1e3c-4798-8dca-403df741691b";
      preLVM = true;
      allowDiscards = true;
    }
  ];
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking = {
    hostName = "quartz"; # Define your hostname.
    hostId = "84821397";
    extraHosts = ''
    127.0.0.1 nbcnews.com www.nbcnews.com
    127.0.0.1 npr.org text.npr.org
    127.0.0.1 cnn.com www.cnn.com
    127.0.0.1 news.google.com
    127.0.0.1 nytimes.com www.nytimes.com
    127.0.0.1 theguardian.com www.theguardian.com
    '';
  };
  virtualisation.docker.enable = true;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "US/Pacific";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];
  environment.systemPackages = with pkgs; [
    chromium
    mkpasswd
    google-chrome
    firefox-beta-bin
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # List services that you want to enable:
  services.avahi = {
    enable = true;
    nssmdns = true;
    # publish.enable = true;
    # publish.addresses = true;
    # publish.workstation = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
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
  # services.printing.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [
      pkgs.hplip
    ];
  };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # 2016-05-14: card stopped working; switching to pcscd fixed it
  # services.pcscd.enable = true;
  # 2017-02-19: stopped working again; setting mode to 666 fixed it
  services.udev.extraRules = ''
    ATTR{idVendor}=="04e6", ATTR{idProduct}=="5119", ENV{ID_SMARTCARD_READER}="1", ENV{ID_SMARTCARD_READER_DRIVER}="gnupg", GROUP+="plugdev", TAG+="uaccess", MODE="666"
  '';

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

    extraUsers.sarah = {
      createHome = true;
      home = "/home/sarah";
      extraGroups = [ "networkmanager" ];
      useDefaultShell = true;
      uid = 1001;
      group = "sarah";
      passwordFile = "/etc/passwd.d/sarah";
    };
    extraGroups.sarah = {
      gid = 1001;
    };
  };
  hardware.trackpoint.emulateWheel = true;

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
