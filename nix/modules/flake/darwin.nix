{
  self,
  inputs,
  ...
}: {
  flake = {
    darwinModules.default = ../darwin;

    darwinConfigurations.lux = let
      unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.aarch64-darwin;
    in inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      
      modules = [
        ../../hosts/darwin/lux
        self.darwinModules.default
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-homebrew.darwinModules.nix-homebrew

        {
          home-manager = {
            useGlobalPkgs = false;
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
