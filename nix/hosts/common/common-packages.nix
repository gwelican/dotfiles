{ inputs, pkgs, unstablePkgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
      unstablePkgs.talosctl
      nil
      rsync
      fping
      fzf
      unstablePkgs.zsh
      zsh-wd
      zsh-z
      pre-commit
      kustomize
      kubectx
      kubernetes-helm
      lsd
      atuin
      starship
      tmux
      watchexec
      nmap
      krew
      pnpm
      kubectl
      direnv
      kubectl-cnpg
      kubectl-ktop
      kubectl-neat
      kubectl-df-pv
      aichat
      comma

      kubectl-rook-ceph

      kubectl-node-shell

      kubectl-view-allocations
      kubecolor


      # devtools
      mosh
      mise
      tailspin
      ncdu

      zoxide
      delta
      difftastic
      bat
      fd
      jq
      gnupg
      ripgrep
      rsync

      pkgs.go-task
      pkgs.lazygit
      # unstablePkgs.jujutsu
      # unstablePkgs.lazyjj
      gcc
      stern
      sops
      mise
      wget
      curl
      fastfetch
      neovim
      up
      ast-grep
      lsd
      atuin
      starship
      tmux
      watchexec
      nmap
      mosh
      parallel
      mise
      ncdu
      zoxide
      delta
      difftastic
      bat
      fd
      jq
      gnupg
      ripgrep
      gcc
      stern
      sops
      wget
      curl
      fastfetch
      neovim
      up
      ast-grep
      topgrade
      glow
    ];
}
