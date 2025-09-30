{ inputs }:
let
  username = "gwelican";
  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.aarch64-darwin;
  hostname = "lux";
  customConfPath = ./../hosts/darwin/${hostname};
  customConf = if builtins.pathExists (customConfPath) then (customConfPath + "/default.nix") else ./../hosts/common/darwin-common-dock.nix;
in
  inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit unstablePkgs; };

    system = "aarch64-darwin";
    modules = [
      # ../hosts/common/common-packages.nix
      ../hosts/common/darwin-common.nix
      ../modules/common-packages.nix
      ../modules/lux-packages.nix
      customConf
      {
        security.sudo.extraConfig = ''
        ${username} ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild, /nix/store/*/bin/darwin-rebuild, /nix/var/nix/profiles/default/bin/nix
        '';
      }
      inputs.home-manager.darwinModules.home-manager {
      }
      {
        home-manager = {
            backupFileExtension = "backup";
            useGlobalPkgs = false;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.${username} = {
              imports = [ ./../home/${username}.nix ];
            };

        };
      }

      inputs.nix-homebrew.darwinModules.nix-homebrew {
        nix-homebrew = {
          enable = true;
          enableRosetta = true;
          autoMigrate = true;
          # mutableTaps = true;
          user = "${username}";
          taps = with inputs; {
            "homebrew/homebrew-core" = homebrew-core;
            "homebrew/homebrew-cask" = homebrew-cask;
            "homebrew/homebrew-bundle" = homebrew-bundle;
          };
        };
      }
      {

      }
    ];
  }
