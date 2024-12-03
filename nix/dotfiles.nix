{ pkgs, config, lib, ... }:
let
  nvimRepo = builtins.fetchGit {
    url = "https://github.com/gwelican/nvim";
    rev = "5de8edb26ec2894d8be727a8052354e88bd54999";
  };
  dotfilesRepo = builtins.fetchGit {
    url = "https://github.com/gwelican/dotfiles";
    rev = "1950d2d7edf805d5a87c8e768f76a179a81f4970";
  };
in
{
  home.file = {
    ".config/nvim_2".source = "${nvimRepo}";
    ".config/starship.toml_2".source = "${dotfilesRepo}/starship/starship.toml";
    ".config/atuin/config.toml_2".source = "${dotfilesRepo}/atuin/atuin.toml";
    ".gitconfig_2".source = "${dotfilesRepo}/git/gitconfig";
    ".gitignore_global_2".source = "${dotfilesRepo}/git/gitignore_global";
    ".tmux.conf_2".source = "${dotfilesRepo}/tmux/tmux.conf";
    ".wezterm.lua_2".source = "${dotfilesRepo}/wezterm/.wezterm.lua";
    ".zshrc_2".source = "${dotfilesRepo}/zsh/zshrc";
    ".zshrc.d_2".source = "${dotfilesRepo}/zsh/zshrc.d";
  };
}
