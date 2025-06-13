{ config, inputs, pkgs, lib, unstablePkgs, ... }:
{
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  programs.nix-index.enable = true;

  home.username = "pvarsanyi";
  home.homeDirectory = "/Users/pvarsanyi";

  # home.packages = [
  #   pkgs.p4v
  # ];

  home.file = {
    ".gitconfig_mergetool".text = ''
      [mergetool "p4merge"]
        cmd = ${pkgs.p4v}/Applications/p4merge.app/Contents/MacOS/p4merge "$BASE" "$REMOTE" "$LOCAL" "$MERGED"
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

}
