{ config, pkgs, ... }:
{
  networking.wireguard.enable = true;

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };

  #  boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  environment.systemPackages = with pkgs; [
    qrencode # to print WireGuard QR codes
  ];

  networking.wireguard.interfaces = {
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      ips = [ "10.0.0.2/24" "fd00::2/48" ];
      listenPort = 51820;

      # Default IPv6 route has lower precedence
      # default via fe80::d6ca:6dff:fe06:c6b1 dev wlp3s0 proto ra metric 600 pref medium
      # default dev wg0 metric 1024 pref medium

      # postSetup = "ip route replace ::/0 dev wg0 metric 50 table main";
      # postShutdown = "ip route delete ::/0 dev wg0 metric 50 table main";

      privateKeyFile = "/etc/nixos-secrets/wireguard/private";

      peers = [
        {
          publicKey = "VfEKXJmJ+moe4DfTv8bDJlHiwQKc4KYaOqzeIacJxG4=";
          # allowedIPs = [ "10.0.0.9/32" "fd00::9/64" ];
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "wg0.i.svends.net:51820";

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
        # {
        #   publicKey = "XX0kFECvZZpdvvCU0pGsJJS2woqsw+puP403tQcX0gc=";
        #   allowedIPs = [ "10.0.0.8/32" "fd00::8/64" ];
        #   endpoint = "wg1.i.svends.net:51820";
        # }
      ];
    };
  };
}
