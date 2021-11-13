{
  inputs = {
    nixos.url = "nixpkgs/release-21.05";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
  };


  outputs = { self, nixos, nixos-unstable, nixpkgs-unstable }: {
    nixosConfigurations.quartz = nixos-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./quartz.nix ];
    };
  };
}
