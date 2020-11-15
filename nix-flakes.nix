{ config, pkgs, ... }:
{
  # Nix Flakes: https://nixos.wiki/wiki/Flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
  };
}
