{ pkgs, lib, ...}: {
  environment.systemPackages = [
    pkgs.rsync
    pkgs.fping
    pkgs.fzf
    pkgs.pre-commit
    pkgs.kustomize
    pkgs.kubectx
    pkgs.kubernetes-helm
    pkgs.lsd
    pkgs.tailspin
    pkgs.atuin
    pkgs.starship
    pkgs.tmux
    # pkgs.helix
    pkgs.zoxide
    pkgs.delta
    pkgs.zellij
    pkgs.bat
    pkgs.fd
    pkgs.jq
    pkgs.ripgrep
    pkgs.delta
    pkgs.rsync
    # pkgs.go-task
    pkgs.lazygit
    pkgs.gcc
    pkgs.stern
    pkgs.sops
    pkgs.mise
  ];
}
