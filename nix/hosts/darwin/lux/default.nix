{ pkgs, lib, ... }:
{
  homebrew.casks = lib.mkMerge [
    [
      "steam"
      "blender"
      "freecad"
      "openscad"
      "plexamp"
      "orcaslicer"
      "nextcloud"
    ]
  ];
}

