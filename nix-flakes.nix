{ config, pkgs, ... }:
{
  # Nix Flakes: https://nixos.wiki/wiki/Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
