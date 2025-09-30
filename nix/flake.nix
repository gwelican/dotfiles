{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
    homebrew-bundle = { url = "github:homebrew/homebrew-bundle"; flake = false; };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-darwin";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";

    flake-parts.url = "github:hercules-ci/flake-parts";
    # flake-parts.inputs.nixpkgs.follows = "nixpkgs";


  };

  outputs = { flake-parts, ... }@ inputs:
     flake-parts.lib.mkFlake { inherit inputs; } {
     systems = [ "x86_64-linux" "aarch64-darwin" ];

      perSystem = { system, pkgs, ... }: {
        # Common packages available on all hosts
        packages = {
          common = pkgs.git;
        };
      };

    # Use top-level flake options for darwin and linux configurations
    flake = {
      darwinConfigurations = {

        lux = import ./hosts/lux.nix { inherit inputs; };
      };
      nixosConfigurations = {
        bastion = import ./hosts/bastion.nix { inherit inputs; };
      };
    };
    };

    # with inputs;
    # let
    #
    #   inherit (self) outputs;
    #
    #   stateVersion = "24.05";
    #   libx = import ./lib { inherit inputs outputs stateVersion; };
    #
    # in {
    #   darwinConfigurations = {
    #     lux = libx.mkDarwin { hostname = "lux"; username = "gwelican"; };
    #     mac = libx.mkDarwin { hostname = "mac"; username = "pvarsanyi"; };
    #     bastion = libx.mkLinux { hostname = "bastion"; username = "gwelican"; };
    #   };
    # };
}
