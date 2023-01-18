{
  inputs = {
    nixos.url = "nixpkgs/release-22.11";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixos, nixos-unstable, nixpkgs-unstable }: {
    nixosConfigurations.quartz = nixos.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./quartz.nix ];
    };
    nixosConfigurations.shale = nixos.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./shale/configuration.nix ];
    };
  };
}
