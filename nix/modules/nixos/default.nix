{pkgs, ...}: {
  imports = [
    ../common-packages.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.zsh.enable = true;

  system.stateVersion = "24.11";
}
