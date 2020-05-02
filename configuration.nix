# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/9e52e0a1-1e3c-4798-8dca-403df741691b";
      preLVM = true;
      allowDiscards = true;
    };
  };
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking = {
    hostName = "quartz"; # Define your hostname.
    hostId = "84821397";
  };

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.0.0.2/24" "fd00::2/48" ];
      # Default IPv6 route has lower precedence
      # default via fe80::d6ca:6dff:fe06:c6b1 dev wlp3s0 proto ra metric 600 pref medium
      # default dev wg0 metric 1024 pref medium
      postSetup = "ip route replace ::/0 dev wg0 metric 50 table main";
      postShutdown = "ip route delete ::/0 dev wg0 metric 50 table main";
      privateKeyFile = "/etc/nixos/wireguard/private";

      peers = [
        {
          publicKey = "S3XliYkSL3e+oX8gU+uBu4fk1RmzHUZYBFzVXLa3zww=";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "[2601:601:e02:dc88:21e:37ff:feda:dd22]:53605";
          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
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
    gcompris
    google-chrome
    (firefox.override { extraNativeMessagingHosts = [ passff-host ]; })
    (firefox-beta-bin.override { extraNativeMessagingHosts = [ passff-host ]; })
    steam
    wireguard
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
      pkgs.epson-escpr2 # Epson ET-3760
      # pkgs.hplip # HP inkjet (obsolete)
    ];
  };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Required by Steam
  hardware.opengl.driSupport32Bit = true;

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
