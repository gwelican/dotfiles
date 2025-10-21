{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome.desktop.macos;
in {
  options.myHome.desktop.macos = {
    enable = lib.mkEnableOption "macOS desktop configuration";
  };

  config = lib.mkIf cfg.enable {
    targets.darwin.defaults = {
      "com.apple.Spotlight".MenuItemHidden = true;

      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "64".enabled = false;
          "65".enabled = false;
        };
      };
    };

    home.packages = with pkgs; [
    ];
  };
}
