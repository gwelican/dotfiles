{ config, pkgs, ... }:
let
  secrets = import ./secrets.nix;
in
{
  # home.username = "pvarsanyi";
  # home.homeDirectory = "/Users/pvarsanyi";
  #


  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = [
    pkgs.git
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # ".config/nvim_2".source = "${nvimRepo}";
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "/Users/pvarsanyi/git/dotfiles/starship/starship.toml";
    ".config/atuin/config.toml".source = config.lib.file.mkOutOfStoreSymlink "/Users/pvarsanyi/git/dotfiles/atuin/atuin.toml";
    ".gitconfig".source = pkgs.substituteAll { src = ../git/gitconfig; git_email = secrets.git_email; };
    # ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "/Users/pvarsanyi/git/dotfiles/git/gitconfig";
    ".gitignore_global".source = config.lib.file.mkOutOfStoreSymlink "/Users/pvarsanyi/git/dotfiles/git/.gitignore_global";
    # ".gitignore_global_2".source = "${dotfilesRepo}/git/gitignore_global";
    # ".tmux.conf_2".source = "${dotfilesRepo}/tmux/tmux.conf";
    # ".wezterm.lua_2".source = "${dotfilesRepo}/wezterm/.wezterm.lua";
    # ".zshrc_2".source = "${dotfilesRepo}/zsh/zshrc";
    # ".zshrc.d_2".source = "${dotfilesRepo}/zsh/zshrc.d";
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

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
    # EDITOR = "emacs";
  };
  programs.git = {
    enable = true;
    # enableAutoConfig = true;
    userName = "Peter Varsanyi";
    userEmail = "email";
  };

  # Let Home Manager install and manage itself.
  #programs.direnv.nix-direnv.enable = true;
  #programs.zsh.enable = true;
  #programs.zsh.enable = true;

}
