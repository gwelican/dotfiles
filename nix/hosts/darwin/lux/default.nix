# Lux host-specific overrides
# This file is OPTIONAL and contains only overrides and additions specific to the "lux" host
# Base configuration (hostname, user, etc.) is handled automatically by the flake
{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  username = config.system.primaryUser; # Use the primary user set by the flake
in {
  # Host-specific sudo permissions (development machine needs more access)
  security.sudo.extraConfig = ''
    ${username} ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild, /nix/store/*/bin/darwin-rebuild, /nix/var/nix/profiles/default/bin/nix
  '';

  # Lux-specific homebrew configuration (development/personal machine needs these taps)
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    autoMigrate = true;
    user = username;
    
    taps = with inputs; {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "sst/homebrew-tap" = homebrew-sst;
    };
  };

  # Lux-specific applications (personal/development tools)
  homebrew.casks = [
    # Development/3D tools
    "steam"
    "blender" 
    "freecad"
    "openscad"
    "orcaslicer"
    
    # Media/Entertainment  
    "plexamp"
    "whisky"
    "stellarium"
    
    # Utilities
    "nextcloud"
  ];
  
  homebrew.brews = [
    "sst/tap/opencode"
    "statix"  
  ];

  # Lux-specific system packages
  environment.systemPackages = with pkgs; [
    # Development tools specific to this machine
    # Add any lux-specific packages here
  ];

  # Lux-specific finder sidebar (personal git directory)
  launchd.user.agents.setFinderSidebar = {
    serviceConfig = {
      KeepAlive = false;
      RunAtLoad = true; 
      ProcessType = "Background";
    };
    script = ''
      ${pkgs.mysides}/bin/mysides remove git 2>/dev/null || true
      ${pkgs.mysides}/bin/mysides add git file:///Users/${username}/git
    '';
  };

  # Lux-specific dock configuration
  system.defaults.dock.persistent-apps = [
    "/Applications/Obsidian.app"
    "/Applications/Spotify.app"
    "/Applications/Floorp.app"
    # "/Applications/Wezterm.app"
    "/Applications/Goose.app"
    "/Applications/Discord.app"
    # Add more lux-specific dock apps here
  ];

  # Other lux-specific system defaults
  system.defaults = {
    dock.tilesize = 64; # Larger dock icons for development machine
    # Add other lux-specific overrides here
  };
}

