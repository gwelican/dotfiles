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
      unstablePkgs.wget
      unstablePkgs.bat
      unstablePkgs.curl
      unstablePkgs.fastfetch
      unstablePkgs.mosh
      unstablePkgs.neovim
      unstablePkgs.parallel
      unstablePkgs.up

# gui
      unstablePkgs.vscode
      unstablePkgs.discord
      unstablePkgs.wezterm
#unstablePkgs.openscad
      unstablePkgs.spotify
      unstablePkgs.p4v
      unstablePkgs.obsidian
      unstablePkgs.telegram-desktop
      ];
}
