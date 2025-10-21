# Shared Modules

This directory contains modules that are shared between Darwin (macOS) and NixOS (Linux) systems.

## Current Modules:

### `packages.nix`
Cross-platform packages that work on both Darwin and Linux:
- **Development tools**: zsh, tmux, neovim, git tools
- **CLI utilities**: bat, fd, ripgrep, jq, fzf
- **Kubernetes tools**: kubectl, helm, k8s utilities  
- **System utilities**: wget, curl, rsync, gnupg
- **Nix tools**: nil, comma

## Usage:

**Darwin modules** import shared packages:
```nix
# modules/darwin/packages.nix
{
  imports = [
    ../shared/packages.nix  # Get cross-platform packages
  ];
  
  environment.systemPackages = with pkgs; [
    karabiner-elements  # Add Darwin-specific packages
    mysides
  ];
}
```

**NixOS modules** import shared packages:  
```nix
# modules/nixos/packages.nix
{
  imports = [
    ../shared/packages.nix  # Get cross-platform packages
  ];
  
  environment.systemPackages = with pkgs; [
    util-linux  # Add Linux-specific packages
    procps
  ];
}
```

This ensures:
- ✅ No package duplication between platforms
- ✅ Easy maintenance (change once, affects both)
- ✅ Platform-specific customization when needed
- ✅ DRY principle for cross-platform tools