# Basic Darwin system configuration
{pkgs, config, ...}: {
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

  # Finder sidebar setup (can be overridden by hosts)
  launchd.user.agents.setFinderSidebar = {
    serviceConfig = {
      KeepAlive = false;
      RunAtLoad = true;
      ProcessType = "Background";
    };
    script = ''
      ${pkgs.mysides}/bin/mysides remove git 2>/dev/null || true
      ${pkgs.mysides}/bin/mysides add git file:///Users/${config.system.primaryUser}/git
    '';
  };
}