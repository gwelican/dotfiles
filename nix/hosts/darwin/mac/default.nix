# Mac host-specific overrides for pvarsanyi user
# This file contains overrides and additions specific to the "mac" host
{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  username = config.system.primaryUser;
in {
  # Mac-specific homebrew configuration (work machine setup)
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    autoMigrate = true;
    user = username;
    
    taps = with inputs; {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };
  };

  # Mac-specific applications (work/development tools)
  homebrew.casks = [
    # Development tools
    "cursor"
    "visual-studio-code"
    
    # Communication
    "discord"
    
    # Utilities
    "brave-browser"
    "wezterm"
    "1password"
    "1password-cli"
    "raycast"
    
    # Media
    "spotify"
    "obsidian"
    "vlc"
  ];
  
  homebrew.brews = [
    "p4v"
  ];

  # Mac-specific system packages
  environment.systemPackages = with pkgs; [
    # Add any mac-specific packages here
  ];

  # Mac-specific dock configuration (work-focused)
  system.defaults.dock.persistent-apps = [
    "/Applications/Cursor.app"
    "/Applications/Visual Studio Code.app"
    "/Applications/Brave Browser.app"
    "/Applications/Wezterm.app"
    "/Applications/Discord.app"
    "/Applications/1Password.app"
    "/Applications/Obsidian.app"
  ];

  # Other mac-specific system defaults
  system.defaults = {
    dock.tilesize = 48; # Standard dock size for work machine
  };
}