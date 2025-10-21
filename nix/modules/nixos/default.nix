# Main NixOS module - imports all NixOS-specific configuration
{pkgs, ...}: {
  imports = [
    ./packages.nix  # Linux-specific and shared packages
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs.zsh.enable = true;

  system.stateVersion = "24.11";
}
