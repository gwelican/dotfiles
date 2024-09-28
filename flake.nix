{
  description = "Home Manager configuration of pvarsanyi";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      macSystem = "aarch64-darwin";
      linuxSystem = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      homeConfig = {system, username, homeDir}: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        modules = [
          ./home.nix
          ./git/default.nix
          ./dotfiles/default.nix
          {
            home.username = username;
            home.homeDirectory = homeDir;
            home.stateVersion = "24.05";
          }
        ];
      };
    in {
      homeConfigurations = {
        linux = homeConfig {
          system = linuxSystem;
          username = "gwelican";
          homeDir = "/home/gwelican";
        };
        mac = homeConfig {
          system = macSystem;
          username = "pvarsanyi";
          homeDir = "/Users/pvarsanyi";
        };
      };
    };
}
