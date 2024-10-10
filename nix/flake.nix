{
  description = "Top level Nix flake";

  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    stablePkgs.url = "github:NixOS/nixpkgs/nixos-24.05";  # Pin to NixOS 24.05


    home-manager.url = "flake:home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs, home-manager, stablePkgs}@ inputs: let
    goTaskPackages = import stablePkgs {
      system = "aarch64-darwin";  # Change for your architecture
    };
    goTask = goTaskPackages.go-task;
    configuration = {pkgs, lib, config, ...}: {

      nixpkgs.config.allowUnfree = true;
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";
      users.users.pvarsanyi.home = /Users/pvarsanyi;

      programs.direnv.enable = true;
      # programs.home-manager.enable = true;
      # programs.fzf.enable = true;
      # programs.neovim.enable = true;
      # programs.zellij.enable = true;
      programs.zsh.enable = true;
      # systemd.user.startServices = "sd-switch";
      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];
    };

  in {

    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {

      modules = [
        configuration
        ./pkgs.nix
        { environment.systemPackages = [ goTask ]; }
      ];
    };
  };
}
