{ config, pkgs, ... }:
{
  services.prometheus = {
    exporters.node = {
      enable = true;
      openFirewall = true;
      firewallFilter = "-i wg0 -p tcp -m tcp --dport 9100";
    };
  };
}
