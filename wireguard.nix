{ config, pkgs, ... }:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [ wireguard ];

  environment.systemPackages = with pkgs; [
    qrencode # to print WireGuard QR codes
    wireguard
  ];

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
  #     privateKeyFile = "/etc/nixos-secrets/wireguard/private";
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
}
