{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qrencode # to print WireGuard QR codes
  ];

  networking.wg-quick.interfaces = {
    # Raspberry Pi
    wg0 = {
      address = [ "10.0.0.2/24" "fd00::2/64" ];
      peers = [
        {
          allowedIPs = [ "10.0.0.0/24" "fd00::/64" ];
          endpoint = "192.168.88.238:51820";
          publicKey = "Kd1JuRVmitgnwVfesMFB5z7E4saFoWSiZPzVuiafn1w=";
        }
        {
          allowedIPs = [ "10.0.0.9/32" "fd00::9/128" ];
          endpoint = "c0.us-west.svends.net:51820";
          publicKey = "VfEKXJmJ+moe4DfTv8bDJlHiwQKc4KYaOqzeIacJxG4=";
        }
      ];
      privateKeyFile = "/etc/nixos-secrets/wireguard/private";
    };
    # # DigitalOcean
    # wg1 = {
    #   address = [ "10.0.0.2/24" "fd00::2/64" ];
    #   # dns = [ "10.0.0.9" ];
    #   peers = [
    #     {
    #       allowedIPs = [ "0.0.0.0/0" "::/0" ];
    #       endpoint = "c0.us-west.svends.net:51820";
    #       publicKey = "VfEKXJmJ+moe4DfTv8bDJlHiwQKc4KYaOqzeIacJxG4=";
    #     }
    #   ];
    #   privateKeyFile = "/etc/nixos-secrets/wireguard/private";
    # };
  };
}
