{ config, pkgs, ... }:
let
  secrets = import ./secrets.nix;
in
{
  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = [
    pkgs.git
  ];

  # home.homeDirectory = "/Users/pvarsanyi";
  # home.username = "gwelican";
  # home.file = {
  #   ".gitconfig_mergetool".text = ''
  #     [mergetool "p4merge"]
  #       cmd = ${pkgs.p4v}/Applications/p4merge.app/Contents/MacOS/p4merge "$BASE" "$REMOTE" "$LOCAL" "$MERGED"
  #   '';
  # };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/pvarsanyi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  #programs.direnv.nix-direnv.enable = true;
  #programs.zsh.enable = true;
  #programs.zsh.enable = true;

}
