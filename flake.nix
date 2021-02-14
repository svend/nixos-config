{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";

  outputs = { self, nixpkgs }: {
      nixosConfigurations.quartz = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [ ./quartz.nix ];
     };
  };
}
