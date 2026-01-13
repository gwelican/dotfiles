{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
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

    homebrew-sst = {
      url = "github:sst/homebrew-tap";
      flake = false;
    };

    homebrew-anomalyco = {
      url = "github:anomalyco/homebrew-tap";
      flake = false;
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin"];

      imports = [
        ./modules/flake
      ];

      perSystem = {
        system,
        pkgs,
        ...
      }: {
        packages = {
          common = pkgs.git;
        };
      };
    };

    # with inputs;
    # let
    #
    #   inherit (self) outputs;

}
