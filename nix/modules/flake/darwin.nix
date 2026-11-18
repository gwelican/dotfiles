{
  self,
  inputs,
  ...
}:
{
  flake = {
    darwinModules.default = ../darwin;

    darwinConfigurations =
      let
        mkDarwinSystem =
          {
            hostname,
            username,
            homeModule,
            system ? "aarch64-darwin",
          }:
          let
            pkgs = inputs.nixpkgs.legacyPackages.${system};
            unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
            # Secrets are decrypted by a host-side sops build, so the derivation must target
            # the machine running nix (CI is x86_64-linux), not the aarch64-darwin target.
            hostPkgs = inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
            hostOverridesPath = ../../hosts/darwin/${hostname}/default.nix;

            # Check if host-specific override file exists
            hostOverrides = if builtins.pathExists hostOverridesPath then [ hostOverridesPath ] else [ ];

            # Decrypt sops secrets at build time (no runtime service)
            ageKeyFile =
              if (builtins.getEnv "SOPS_AGE_KEY_FILE" != "") then
                builtins.getEnv "SOPS_AGE_KEY_FILE"
              else
                (builtins.getEnv "HOME" + "/.config/sops/age/keys.txt");
            ageKeyContent = builtins.readFile ageKeyFile;
            secretsJson =
              hostPkgs.runCommand "secrets-json"
                {
                  nativeBuildInputs = [ hostPkgs.sops ];
                  SOPS_AGE_KEY = ageKeyContent;
                }
                ''
                  sops --decrypt --output-type json ${../../secrets.sops.yaml} > $out
                '';
            secrets = builtins.fromJSON (builtins.readFile secretsJson);

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

          in
          inputs.nix-darwin.lib.darwinSystem {
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
                  extraSpecialArgs = {
                    inherit self inputs unstablePkgs;
                    bastion_host = secrets.bastion_host;
                  };
                  backupFileExtension = "backup";
                  users.${username}.imports = [ homeModule ];
                };
                nixpkgs.config.allowUnfree = true;
              }
            ]
            ++ hostOverrides; # Only add host overrides if the file exists

            specialArgs = { inherit self inputs unstablePkgs; };
          };
      in
      {
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
