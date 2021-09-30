{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qrencode # to print WireGuard QR codes
  ];

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.0.0.2/24" "fd00::2/64" ];
      dns = [ "1.1.1.1" ];
      # dns = [ "10.0.0.9" ];
      peers = [
        {
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "192.168.0.21:51820";
          publicKey = "Kd1JuRVmitgnwVfesMFB5z7E4saFoWSiZPzVuiafn1w=";
          # endpoint = "c0.us-west.svends.net:51820";
          # publicKey = "VfEKXJmJ+moe4DfTv8bDJlHiwQKc4KYaOqzeIacJxG4=";
        }
      ];
      privateKeyFile = "/etc/nixos-secrets/wireguard/private";
    };
  };
}
