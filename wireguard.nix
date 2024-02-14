{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    qrencode # to print WireGuard QR codes
  ];

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [
        "10.0.0.10/24"
        "fd00::10/64"
      ];
      peers = [
        # Raspberry Pi
        {
          # allowedIPs = [ "0.0.0.0/0" "::/0" ]; # route all traffic through WG
          allowedIPs = [
            "10.0.0.0/24"
            "fd00::/64"
          ];
          endpoint = "10.10.0.238:51820";
          publicKey = "Kd1JuRVmitgnwVfesMFB5z7E4saFoWSiZPzVuiafn1w=";
        }
        # # Digital Ocean
        # {
        #   allowedIPs = [ "10.0.0.9/32" "fd00::9/128" ];
        #   endpoint = "c0.us-west.svends.net:51820";
        #   publicKey = "VfEKXJmJ+moe4DfTv8bDJlHiwQKc4KYaOqzeIacJxG4=";
        # }
      ];
      # sudo mkdir -p -m 700 /etc/nixos-secrets/wireguard
      # wg genkey | sudo tee /etc/nixos-secrets/wireguard/private >/dev/null
      privateKeyFile = "/etc/nixos-secrets/wireguard/private";
    };
  };
}
