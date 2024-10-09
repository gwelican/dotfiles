{
  description = "Top level Nix flake";

  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixpkgs/nixos-24.05";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "flake:home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager}: let
    configuration = {pkgs, lib, config, ...}: {
      environment.systemPackages = [
        pkgs.rsync
        pkgs.fping
        pkgs.fzf
        pkgs.pre-commit
        pkgs.kustomize
        pkgs.kubectx
        pkgs.kubernetes-helm
        pkgs.lsd
        pkgs.atuin
        pkgs.starship
        pkgs.tmux
        pkgs.helix
        pkgs.zoxide
        pkgs.delta
        pkgs.zellij
        pkgs.bat
        pkgs.fd
        pkgs.jq
        pkgs.ripgrep
        pkgs.delta
        pkgs.rsync
        pkgs.go-task
        pkgs.gcc
        pkgs.stern
        pkgs.sops
        pkgs.mise
      ];
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
      # systemd.user.startServices = "sd-switch";
    };
  in {
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        # home-manager.darwinModules.home-manager
        # {
        #   home-manager.useGlobalPkgs = true;
        #   home-manager.useUserPackages = true;
        #   home-manager.users.pvarsanyi = import ./home.nix;
        # }
      ];
    };
  };
}
