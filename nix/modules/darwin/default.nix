{pkgs, ...}: {
  imports = [
    ../common-packages.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
