{
  inputs,
  pkgs,
  lib,
  ...
}: let
  username = "gwelican";
  hostname = "lux";
in {
  imports = [
    ../../common/darwin-common.nix
    ../../common/darwin-common-dock.nix
    ../../../modules/lux-packages.nix
  ];

  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  security.sudo.extraConfig = ''
    ${username} ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/darwin-rebuild, /nix/store/*/bin/darwin-rebuild, /nix/var/nix/profiles/default/bin/nix
  '';

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

  homebrew.casks = lib.mkMerge [
    [
      "steam"
      "blender"
      "freecad"
      "openscad"
      "plexamp"
      "orcaslicer"
      "nextcloud"
      "whisky"
      "stellarium"
    ]
  ];
  
  homebrew.brews = lib.mkMerge [
    [
      "sst/tap/opencode"
      "statix"
    ]
  ];
}

