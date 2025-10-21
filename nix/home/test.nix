{ config, pkgs, lib, self, ... }:{
  # imports = [self.homeManagerModules.default];
  config = lib.mkMerge [
    (lib.mkIf pkgs.stdenv.isDarwin {
      home = {
        homeDirectory = "/Users/gwelican";
        shellAliases."docker" = "podman";
      };

      myHome = {
        aly.desktop.macos.enable = true;
        services.raycast.enable = true;
      };
    })
  ];
}
