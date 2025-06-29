{ inputs, outputs, stateVersion, ... }:
{
  mkLinux = { hostname, username ? "gwelican", system ? "x86_64-linux" }:
  let
    inherit (inputs.nixpkgs) lib;
    unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
    customConfPath = ./../hosts/linux/${hostname};
  in
  inputs.nix-darwin.lib.darwinSystem {
    specialArgs = { inherit system inputs username unstablePkgs; };
    modules = [
      ./../hosts/common/common-packages.nix
      ./../hosts/common/linux-common.nix
      ./../hosts/linux/${hostname}
    ];

  };

  mkDarwin = { hostname, username ? "gwelican", system ? "aarch64-darwin" }:
  let
    inherit (inputs.nixpkgs) lib;
    unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
    customConfPath = ./../hosts/darwin/${hostname};
    customConf = if builtins.pathExists (customConfPath) then (customConfPath + "/default.nix") else ./../hosts/common/darwin-common-dock.nix;
  in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = { inherit system inputs username unstablePkgs; };
      #extraSpecialArgs = { inherit inputs; }
      modules = [
        ../hosts/common/common-packages.nix
        ../hosts/common/darwin-common.nix
        customConf
        # Add nodejs overlay to fix build issues (https://github.com/NixOS/nixpkgs/issues/402079)
        # {
        #   nixpkgs.overlays = [
        #     (final: prev: {
        #       nodejs = prev.nodejs_22;
        #       nodejs-slim = prev.nodejs-slim_22;
        #     })
        #   ];
        {
         security.sudo.extraConfig = ''
         ${username} ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild, /nix/store/*/bin/darwin-rebuild, /nix/var/nix/profiles/default/bin/nix
         '';
        }

        inputs.home-manager.darwinModules.home-manager {
            networking.hostName = hostname;
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.sharedModules = [ inputs.mac-app-util.homeManagerModules.default ];
            home-manager.users.${username} = { imports = [ ./../home/${username}.nix ]; };
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

      ];
    };
}
