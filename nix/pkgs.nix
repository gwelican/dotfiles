
{ unstablePkgs, stablePkgs, ...}:
builtins.trace "Loading pkgs.nix" (
let
  isDarwin = unstablePkgs.stdenv.isDarwin;
  macPackages = [
    unstablePkgs.mkalias
  ];
  commonPackages = [
    # taskWrapper
    unstablePkgs.nil
    unstablePkgs.rsync
    unstablePkgs.fping
    unstablePkgs.fzf
    unstablePkgs.zsh
    unstablePkgs.zsh-wd
    unstablePkgs.zsh-z
    unstablePkgs.pre-commit
    unstablePkgs.kustomize
    unstablePkgs.kubectx
    unstablePkgs.kubernetes-helm
    unstablePkgs.lsd
    unstablePkgs.atuin
    unstablePkgs.starship
    unstablePkgs.tmux
    unstablePkgs.watchexec
    unstablePkgs.nmap
    unstablePkgs.krew
    unstablePkgs.pnpm
    unstablePkgs.kubectl
    unstablePkgs.direnv
    unstablePkgs.kubectl-cnpg
    unstablePkgs.kubectl-ktop
    unstablePkgs.kubectl-neat
    unstablePkgs.kubectl-df-pv

    unstablePkgs.kubectl-rook-ceph

    unstablePkgs.kubectl-node-shell

    unstablePkgs.kubectl-view-allocations
    unstablePkgs.kubecolor


    # devtools
    unstablePkgs.mosh
    unstablePkgs.mise
    unstablePkgs.tailspin
    unstablePkgs.ncdu
    # pkgs.helix
    unstablePkgs.zoxide
    unstablePkgs.delta
    unstablePkgs.difftastic
    unstablePkgs.bat
    unstablePkgs.fd
    unstablePkgs.jq
    unstablePkgs.gnupg
    unstablePkgs.ripgrep
    unstablePkgs.rsync
    
    stablePkgs.go-task
    unstablePkgs.lazygit
    unstablePkgs.jj
    unstablePkgs.lazyjj
    unstablePkgs.gcc
    unstablePkgs.stern
    unstablePkgs.sops
    unstablePkgs.mise
    unstablePkgs.wget
    unstablePkgs.curl
    unstablePkgs.fastfetch
    unstablePkgs.neovim
    unstablePkgs.up
    unstablePkgs.ast-grep
    unstablePkgs.lsd
    unstablePkgs.tailspin
    unstablePkgs.atuin
    unstablePkgs.starship
    unstablePkgs.tmux
    unstablePkgs.watchexec
    unstablePkgs.nmap
    unstablePkgs.mosh
    unstablePkgs.parallel
    unstablePkgs.mise
    unstablePkgs.ncdu
    unstablePkgs.zoxide
    unstablePkgs.delta
    unstablePkgs.difftastic
    unstablePkgs.bat
    unstablePkgs.fd
    unstablePkgs.jq
    unstablePkgs.gnupg
    unstablePkgs.ripgrep
    unstablePkgs.gcc
    unstablePkgs.stern
    unstablePkgs.sops
    unstablePkgs.wget
    unstablePkgs.curl
    unstablePkgs.fastfetch
    unstablePkgs.neovim
    unstablePkgs.up
    unstablePkgs.ast-grep
    unstablePkgs.topgrade
    unstablePkgs.glow
    unstablePkgs.cowsay
  ];
  guiPackages = [
    unstablePkgs.p4v
    unstablePkgs.karabiner-elements
    unstablePkgs.fira-code
    unstablePkgs.vscode
    unstablePkgs.discord
    unstablePkgs.wezterm
    unstablePkgs.spotify
    unstablePkgs.obsidian
    # unstablePkgs.ghostty
    # unstablePkgs.openscad
  ];
in

  if isDarwin then {
  environment.systemPackages = commonPackages ++ guiPackages ++ macPackages;
} else {
  home.packages = commonPackages;
}
)
