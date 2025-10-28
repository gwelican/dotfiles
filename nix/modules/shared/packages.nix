# Cross-platform packages shared between Darwin and Linux systems
{pkgs, unstablePkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Nix tools
    nil
    comma

    # Essential system utilities (cross-platform)
    rsync
    fping
    rclone
    fzf
    zoxide
    mkcert
    delta
    iperf
    difftastic
    bat
    fd
    jq
    gnupg
    ripgrep
    gcc
    wget
    curl
    fastfetch
    neovim
    up
    ast-grep
    topgrade
    glow
    parallel
    ncdu
    nmap
    mosh
    chezmoi

    # Development tools (cross-platform)
    unstablePkgs.zsh
    zsh-wd
    zsh-z
    pre-commit
    lsd
    atuin
    starship
    tmux
    watchexec
    pnpm
    direnv
    aichat
    mise
    tailspin
    stern
    sops
    go-task
    lazygit

    # Kubernetes tools (cross-platform)
    unstablePkgs.talosctl
    kustomize
    kubectx
    kubernetes-helm
    krew
    kubectl
    kubectl-cnpg
    kubectl-ktop
    kubectl-neat
    kubectl-df-pv
    kubectl-rook-ceph
    kubectl-node-shell
    kubectl-view-allocations
    kubecolor

    # Platform-agnostic packages that might be useful
    # unstablePkgs.ghostty  # Cross-platform terminal
  ];
}
