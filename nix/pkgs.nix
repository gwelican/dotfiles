{ upkgs, spkgs, architecture, ...}:
let
  stablePkgs = import spkgs {
    system = architecture;
    config = { allowUnfree = true; };

  };
  unstablePkgs = import upkgs {
    system = architecture;
    config = { allowUnfree = true; };
  };
in {
  environment.systemPackages = [
    stablePkgs.go-task
    unstablePkgs.mkalias
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
    unstablePkgs.tailspin
    unstablePkgs.atuin
    unstablePkgs.starship
    unstablePkgs.tmux
    unstablePkgs.watchexec
    unstablePkgs.nmap

    # devtools
    unstablePkgs.mosh
    unstablePkgs.parallel
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
    # pkgs.go-task
    unstablePkgs.lazygit
    unstablePkgs.gcc
    unstablePkgs.stern
    unstablePkgs.sops
    unstablePkgs.mise
    unstablePkgs.wget
    unstablePkgs.curl
    unstablePkgs.fastfetch
    unstablePkgs.neovim
    unstablePkgs.parallel
    unstablePkgs.up
    unstablePkgs.ast-grep

    # gui
    unstablePkgs.p4v
    # unstablePkgs.openscad
    unstablePkgs.karabiner-elements

    unstablePkgs.fira-code
    unstablePkgs.vscode
    unstablePkgs.discord
    unstablePkgs.topgrade
    unstablePkgs.glow
    # unstablePkgs.ghostty
    unstablePkgs.wezterm
    unstablePkgs.spotify
    unstablePkgs.p4v
    unstablePkgs.obsidian
  ];
}
