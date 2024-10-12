{ upkgs, spkgs, architecture, ...}:
let
  stablePkgs = import spkgs {
    system = architecture;
  };
  unstablePkgs = import upkgs {
    system = architecture;
  };
  in {
  environment.systemPackages = [
    stablePkgs.go-task
    unstablePkgs.rsync
    unstablePkgs.fping
    unstablePkgs.fzf
    unstablePkgs.pre-commit
    unstablePkgs.kustomize
    unstablePkgs.kubectx
    unstablePkgs.kubernetes-helm
    unstablePkgs.lsd
    unstablePkgs.tailspin
    unstablePkgs.atuin
    unstablePkgs.starship
    unstablePkgs.tmux
    # pkgs.helix
    unstablePkgs.zoxide
    unstablePkgs.delta
    unstablePkgs.zellij
    unstablePkgs.bat
    unstablePkgs.fd
    unstablePkgs.jq
    unstablePkgs.ripgrep
    unstablePkgs.delta
    unstablePkgs.rsync
    # pkgs.go-task
    unstablePkgs.lazygit
    unstablePkgs.gcc
    unstablePkgs.stern
    unstablePkgs.sops
    unstablePkgs.mise
  ];
}
