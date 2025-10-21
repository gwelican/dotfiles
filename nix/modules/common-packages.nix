{ pkgs, unstablePkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Nix tools
    nil
    comma
    
    # System tools
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
    
    # Dev tools
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
    
    # Kubernetes tools
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
  ];
}

