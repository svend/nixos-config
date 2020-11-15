{ config, pkgs, ... }:
{
  boot.kernelModules = [ "i2c_dev" ]; # i2c_dev for DDC support (/dev/i2c-*)

  # DDC support (/dev/i2c-*)
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", TAG+="uaccess"
  '';

  systemd.services.display-switch =
    let
      display-switch-config = pkgs.runCommand "display-switch-config"
        {
          config = ./config/display-switch/display-switch.ini;
        } ''
        mkdir -p "$out/display-switch"
        cp "$config" "$out/display-switch/display-switch.ini"
      '';
    in
    {
      description = "USB-triggered display switch";
      environment = {
        XDG_CONFIG_HOME = display-switch-config;
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.display-switch}/bin/display_switch";
      };
      wantedBy = [ "default.target" ];
    };
}
