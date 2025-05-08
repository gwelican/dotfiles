{
  description = "Top level Nix flake";

  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixos-unstable";
    stablePkgs.url = "github:NixOS/nixpkgs/nixos-24.05";  # Pin to NixOS 24.05

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager.url = "flake:home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs, home-manager, stablePkgs, nix-homebrew}@ inputs:
    let
      secrets = ./secrets.nix;
      macConfiguration = {pkgs, lib, config, ...}: {
        nix.settings.experimental-features = "nix-command flakes";
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 5;
        nixpkgs.hostPlatform = "aarch64-darwin";
        users.users.pvarsanyi.home = /Users/pvarsanyi;

        homebrew = {
          enable = true;
          taps = [
            "withgraphite/tap"
          ];
          brews = [
            "mas"
            # "tailscale"
            "graphite"
          ];
          casks = [
            "hammerspoon"
            "ghostty"
            "rustdesk"
            "appcleaner"
          ];
          #   "hammerspoon"
          #   "firefox"
          #   "iina"
          #   "the-unarchiver"
          # ];
          # masApps = {
          #   "Telegram" = 747648890;
          # };
          onActivation.cleanup = "none";
        };

        system.defaults = {
          dock.autohide = false;
          NSGlobalDomain.AppleICUForce24HourTime = true;
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
          NSGlobalDomain.KeyRepeat = 2;
          dock.persistent-apps = [
            "${pkgs.obsidian}/Applications/Obsidian.app"
            "${pkgs.wezterm}/Applications/Wezterm.app"
            "${pkgs.spotify}/Applications/Spotify.app"
            "/Applications/Telegram.app"
            "/Applications/Slack.app"
            "/Applications/WezTerm.app"
            "/Applications/Discord.app"
            "/Applications/Messenger.app"
          ];
        };

        programs.direnv.enable = true;
        programs.zsh.enable = true;

        # programs.home-manager.enable = true;
        # programs.fzf.enable = true;
        # programs.neovim.enable = true;
        # programs.zellij.enable = true;
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
        echo "setting up ${env}/Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            done
          '';

        # fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
      };

    in {
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "bak";
              # useGlobalPkgs = true;
              users.pvarsanyi = import ./mac-home.nix;
            };
          }
          macConfiguration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "pvarsanyi";
              autoMigrate = true;
            };
          }
          (
            import ./pkgs.nix {
              unstablePkgs = nixpkgs.legacyPackages.aarch64-darwin;
              stablePkgs = stablePkgs.legacyPackages.aarch64-darwin;
            }
          )
        ];
      };
      homeConfigurations."bastion" = builtins.trace "✅ Evaluating homeConfiguration for bastion" home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
          {
            home = {
              username = "gwelican";
              homeDirectory = "/home/gwelican";
            };
          }
          (import ./pkgs.nix {
            unstablePkgs = nixpkgs.legacyPackages.x86_64-linux;
            stablePkgs = stablePkgs.legacyPackages.x86_64-linux;
          })
        ];
      };
    };
}
