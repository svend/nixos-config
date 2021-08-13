{ config, pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "bme280";
        static_configs = [{
          targets = [
            "192.168.88.227:9500"
          ];
        }];
      }
    ];

    exporters.node = {
      enable = true;
      openFirewall = true;
      firewallFilter = "-i wg0 -p tcp -m tcp --dport 9100";
    };
  };
}
