{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.default = ../nixos;

    nixosConfigurations.bastion = let
      unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
    in inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      modules = [
        ../../hosts/linux/bastion
        self.nixosModules.default
        inputs.home-manager.nixosModules.home-manager

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit self inputs unstablePkgs;};
            backupFileExtension = "backup";
            users.gwelican.imports = [self.homeModules.gwelican];
          };

          nixpkgs.config.allowUnfree = true;
        }
      ];

      specialArgs = {inherit self inputs unstablePkgs;};
    };
  };
}
