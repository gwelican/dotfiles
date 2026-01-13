{
  self,
  inputs,
  ...
}: {
  flake = {
    darwinModules.default = ../darwin;

    darwinConfigurations = let
      mkDarwinSystem = {
        hostname,
        username,
        homeModule,
        system ? "aarch64-darwin",
      }: let
        unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
        hostOverridesPath = ../../hosts/darwin/${hostname}/default.nix;
        
        # Check if host-specific override file exists
        hostOverrides = if builtins.pathExists hostOverridesPath then [hostOverridesPath] else [];
        
        # Base host configuration with user settings
        baseHostConfig = {
          networking.hostName = hostname;
          networking.computerName = hostname;
          system.defaults.smb.NetBIOSName = hostname;
          system.primaryUser = username;
          
          users.users.${username} = {
            name = username;
            home = "/Users/${username}";
          };
        };
        
      in inputs.nix-darwin.lib.darwinSystem {
        inherit system;
        
        modules = [
          # Base Darwin configuration (system, packages, homebrew, defaults, fonts)
          self.darwinModules.default

          # Base host configuration (hostname, user, etc.)
          baseHostConfig

          # External modules
          inputs.home-manager.darwinModules.home-manager
          inputs.nix-homebrew.darwinModules.nix-homebrew

          {
            nixpkgs.overlays = [ inputs.neovim-nightly.overlays.default ];
          }

          {
            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = true;
              extraSpecialArgs = {inherit self inputs unstablePkgs;};
              backupFileExtension = "backup";
              users.${username}.imports = [homeModule];
            };

            nixpkgs.config.allowUnfree = true;
          }
        ] ++ hostOverrides; # Only add host overrides if the file exists

        specialArgs = {inherit self inputs unstablePkgs;};
      };
    in {
      # Personal development machine (gwelican user, with overrides)
      lux = mkDarwinSystem {
        hostname = "lux";
        username = "gwelican";
        homeModule = self.homeModules.gwelican;
      };
      
      # Work/other machine (pvarsanyi user, may or may not have overrides)
      mac = mkDarwinSystem {
        hostname = "mac";
        username = "pvarsanyi";
        homeModule = self.homeModules.pvarsanyi;
      };
      
      # Example: You could add a work machine like this:
      # work-macbook = mkDarwinSystem {
      #   hostname = "work-macbook";
      #   username = "pvarsanyi";  # or your work username
      #   homeModule = self.homeModules.pvarsanyi;
      # };
      # 
      # Then optionally create hosts/darwin/work-macbook/default.nix with work-specific overrides
    };
  };
}
