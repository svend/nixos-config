{
  inputs = {
    nixos.url = "nixpkgs/release-21.05";
    nixos-next.url = "nixpkgs/release-21.11";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
  };


  outputs = { self, nixos, nixos-next, nixos-unstable, nixpkgs-unstable }: {
    nixosConfigurations.quartz = nixos-next.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./quartz.nix ];
    };
  };
}
