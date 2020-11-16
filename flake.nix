{
  outputs = { self, nixpkgs }: {
      nixosConfigurations.quartz = nixpkgs.lib.nixosSystem {
       system = "x86_64-linux";
       modules = [ ./configuration.nix ];
     };
  };
}
