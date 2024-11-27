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
    macConfiguration = {pkgs, lib, config, ...}: {

      nixpkgs.config.allowUnfree = true;
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";
      users.users.pvarsanyi.home = /Users/pvarsanyi;

      system.defaults = {
        dock.autohide = false;
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.KeyRepeat = 2;
        dock.persistent-apps = [
          # "${pkgs.alacritty}/Applications/Alacritty.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "${pkgs.wezterm}/Applications/Wezterm.app"
          "${pkgs.spotify}/Applications/Spotify.app"
          "${pkgs.telegram-desktop}/Applications/Telegram.app"
          # "/System/Applications/Mail.app"
          # "/System/Applications/Calendar.app"
        ];
      };

      programs.direnv.enable = true;
      # programs.home-manager.enable = true;
      # programs.fzf.enable = true;
      # programs.neovim.enable = true;
      # programs.zellij.enable = true;
      programs.zsh.enable = true;
      # systemd.user.startServices = "sd-switch";
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read src; do
          app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            done
            '';
      fonts.packages = [
        (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];
    };

  in {
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        macConfiguration
          (import ./pkgs.nix {
           upkgs = nixpkgs;
           spkgs = stablePkgs;
           architecture = "aarch64-darwin";
           })
      ];
    };
  };
}
