# Basic Darwin system configuration
{pkgs, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
    channel.enable = false;
  };
  
  system.stateVersion = 5;
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };

  # Enable essential programs
  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];
  programs.nix-index.enable = true;
  programs.direnv.enable = true;
}